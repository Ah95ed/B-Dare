import { Env } from './index';
import type { KVNamespace, DurableObject, DurableObjectState } from '@cloudflare/workers-types';

// Extend Env interface to include KV and other environment variables
interface ExtendedEnv extends Env {
    GAME_STATE_KV?: KVNamespace;
    ENVIRONMENT?: string;
}

interface PlayerInfo {
    id: string;
    name: string;
    isHost: boolean;
    score: number;
    correctAnswers: number;
    wrongAnswers: number;
    joinedAt: number;
    token?: string; // Player authentication token
}

interface GameState {
    puzzle: Puzzle | null;
    gameType?: string;
    currentStep: number;
    chosenNodes: LinkNode[];
    score: number;
    remainingSeconds: number;
    startTime: number | null;
    currentPlayerIndex: number;
    isGameStarted: boolean;
    isGameOver: boolean;
    gameSpecificData?: Record<string, any>; // بيانات خاصة بكل نمط
}

interface LinkNode {
    id: string;
    label: string;
    iconName?: string;
    imagePath?: string;
    representationType: string;
    labels?: Record<string, string>;
}

interface PuzzleStep {
    order: number;
    timeLimit: number;
    options: Array<{
        node: LinkNode;
        isCorrect: boolean;
    }>;
}

interface Puzzle {
    id: string;
    gameType?: string; // نوع اللعبة (mysteryLink, memoryFlip, etc.)
    type: string;
    category?: string;
    difficulty?: string;
    start: LinkNode;
    end: LinkNode;
    linksCount: number;
    timeLimit: number;
    steps: PuzzleStep[];
    gameTypeData?: Record<string, any>; // بيانات خاصة بكل نمط
}

interface GameConfig {
    gameType?: string;
    representationType: string;
    linksCount: number;
    category?: string;
    puzzleId?: string;
    puzzle?: Puzzle; // Puzzle object كامل
}

interface ClientMessage {
    type: string;
    [key: string]: any;
}

interface JwtPayload {
    sub?: string;
    exp?: number;
    playerId?: string;
    [key: string]: unknown;
}

interface JwtHeader {
    alg?: string;
    [key: string]: unknown;
}

const textEncoder = new TextEncoder();
const textDecoder = new TextDecoder();

export class GameRoom implements DurableObject {
    private state: DurableObjectState;
    private env: ExtendedEnv;
    private sessions: Map<string, WebSocket> = new Map();
    private players: Map<string, PlayerInfo> = new Map();
    private gameState: GameState | null = null;
    private timerInterval: number | null = null;
    private rateLimiter: Map<string, number[]> = new Map(); // playerId -> timestamps
    private readonly MAX_REQUESTS_PER_SECOND = 10;
    private readonly RATE_LIMIT_WINDOW_MS = 1000; // 1 second

    constructor(state: DurableObjectState, env: ExtendedEnv) {
        this.state = state;
        this.env = env;
    }

    private checkRateLimit(playerId: string): boolean {
        const now = Date.now();
        const timestamps = this.rateLimiter.get(playerId) || [];

        // إزالة الطلبات القديمة خارج النافذة الزمنية
        const recentTimestamps = timestamps.filter(ts => now - ts < this.RATE_LIMIT_WINDOW_MS);

        if (recentTimestamps.length >= this.MAX_REQUESTS_PER_SECOND) {
            return false; // تجاوز الحد
        }

        // إضافة الطلب الحالي
        recentTimestamps.push(now);
        this.rateLimiter.set(playerId, recentTimestamps);

        return true; // ضمن الحد
    }

    async fetch(request: any): Promise<any> {
        // Upgrade to WebSocket
        const upgradeHeader = request.headers.get('Upgrade');
        if (upgradeHeader !== 'websocket') {
            return new Response('Expected WebSocket', { status: 426 });
        }

        if (!this.isOriginAllowed(request)) {
            return new Response('Forbidden', { status: 403 });
        }

        const pair = new (globalThis as any).WebSocketPair();
        const [client, server] = Object.values(pair);

        await this.handleSession(server, request);

        return new Response(null, {
            status: 101,
            webSocket: client,
        } as any);
    } private async validatePlayerToken(playerId: string, token?: string): Promise<boolean> {
        const environment = (this.env.ENVIRONMENT || 'development').toLowerCase();
        const requiresToken = environment === 'production';

        if (!token) {
            return !requiresToken;
        }

        const secret = this.env.JWT_SECRET;
        if (!secret) {
            this.logEvent('jwt_secret_missing', { playerId });
            return !requiresToken;
        }

        try {
            const payload = await verifyJwt(token, secret);
            if (!payload) {
                return false;
            }

            if (payload.exp && Date.now() >= payload.exp * 1000) {
                return false;
            }

            const expectedPlayerId = payload.playerId || payload.sub;
            if (expectedPlayerId && expectedPlayerId !== playerId) {
                return false;
            }

            return true;
        } catch (error) {
            this.logEvent('jwt_verification_failed', {
                playerId,
                error: error instanceof Error ? error.message : String(error),
            });
            console.error('JWT verification failed', error);
            return false;
        }
    }

    private isOriginAllowed(request: Request): boolean {
        const origin = request.headers.get('Origin');
        if (!origin) {
            return true;
        }

        const environment = (this.env.ENVIRONMENT || 'development').toLowerCase();
        const allowedOrigins = this.env.ALLOWED_ORIGINS
            ?.split(',')
            .map((value) => value.trim())
            .filter((value) => value.length > 0) || [];

        if (allowedOrigins.includes('*')) {
            return true;
        }

        if (environment === 'production' && allowedOrigins.length === 0) {
            return false;
        }

        return allowedOrigins.length === 0 || allowedOrigins.includes(origin);
    }

    async handleSession(ws: any, request: any): Promise<void> {
        const url = new URL(request.url);
        const playerId = url.searchParams.get('playerId') || this.generateId();
        const playerName = url.searchParams.get('playerName') || `Player ${this.players.size + 1}`;
        const isHost = this.players.size === 0;
        const authHeader = request.headers.get('Authorization') || '';
        const headerToken = authHeader.startsWith('Bearer ') ? authHeader.slice(7).trim() : undefined;
        const token = url.searchParams.get('token') || headerToken || undefined;

        const isTokenValid = await this.validatePlayerToken(playerId, token);
        if (!isTokenValid) {
            ws.accept();
            ws.send(JSON.stringify({ type: 'error', message: 'Unauthorized' }));
            ws.close(4401, 'Unauthorized');
            this.logEvent('unauthorized_connection', { playerId });
            return;
        }

        ws.accept();

        // إضافة اللاعب
        const playerInfo: PlayerInfo = {
            id: playerId,
            name: playerName,
            isHost,
            score: 0,
            correctAnswers: 0,
            wrongAnswers: 0,
            joinedAt: Date.now(),
        };

        this.sessions.set(playerId, ws);
        this.players.set(playerId, playerInfo);

        // إرسال حالة اللعبة الحالية للاعب الجديد
        this.sendToPlayer(playerId, {
            type: 'connected',
            playerId,
            isHost,
            gameState: this.gameState,
            players: Array.from(this.players.values()),
        });

        // إشعار اللاعبين الآخرين
        this.broadcast(
            {
                type: 'playerJoined',
                player: playerInfo,
                players: Array.from(this.players.values()),
            },
            playerId
        );

        // معالجة الرسائل الواردة
        ws.addEventListener('message', async (event: any) => {
            try {
                const message = JSON.parse(event.data as string) as ClientMessage;
                await this.handleMessage(playerId, message);
            } catch (e) {
                console.error('Error handling message:', e);
                this.sendToPlayer(playerId, {
                    type: 'error',
                    message: 'Invalid message format',
                });
            }
        });

        // تنظيف عند انقطاع الاتصال
        ws.addEventListener('close', () => {
            this.sessions.delete(playerId);
            const wasHost = this.players.get(playerId)?.isHost;
            this.players.delete(playerId);

            // إذا كان المضيف انقطع، نقل المضيفية للاعب التالي
            if (wasHost && this.players.size > 0) {
                const firstPlayer = Array.from(this.players.values())[0];
                firstPlayer.isHost = true;
                this.players.set(firstPlayer.id, firstPlayer);
            }

            this.broadcast({
                type: 'playerLeft',
                playerId,
                players: Array.from(this.players.values()),
            });

            // إذا لم يعد هناك لاعبين، إيقاف المؤقت
            if (this.players.size === 0) {
                this.stopTimer();
            }
        });
    }

    private logEvent(eventType: string, data: Record<string, any>): void {
        console.log(JSON.stringify({
            type: 'game_event',
            eventType,
            timestamp: Date.now(),
            roomId: this.state.id.toString(),
            ...data,
        }));
    }

    async handleMessage(playerId: string, message: ClientMessage): Promise<void> {
        const startTime = Date.now();

        try {
            // Rate Limiting
            if (!this.checkRateLimit(playerId)) {
                this.logEvent('rate_limit_exceeded', { playerId });
                this.sendToPlayer(playerId, {
                    type: 'error',
                    message: 'Rate limit exceeded. Please slow down.',
                });
                return;
            }

            const player = this.players.get(playerId);
            if (!player) {
                this.logEvent('player_not_found', { playerId });
                this.sendToPlayer(playerId, { type: 'error', message: 'Player not found' });
                return;
            }

            this.logEvent('message_received', {
                playerId,
                messageType: message.type,
            });

            switch (message.type) {
                case 'startGame':
                    // التحقق من أن اللاعب هو Host
                    if (!player.isHost) {
                        this.sendToPlayer(playerId, {
                            type: 'error',
                            message: 'Only host can start the game',
                        });
                        return;
                    }
                    // التحقق من أن اللعبة لم تبدأ بعد
                    if (this.gameState?.isGameStarted) {
                        this.sendToPlayer(playerId, {
                            type: 'error',
                            message: 'Game already started',
                        });
                        return;
                    }
                    await this.startGame(message.config as GameConfig);
                    break;

                case 'selectOption':
                    await this.handleOptionSelection(playerId, message);
                    break;

                case 'flipCard':
                    await this.handleCardFlip(playerId, message);
                    break;

                case 'selectItem':
                    await this.handleItemSelection(playerId, message);
                    break;

                case 'moveItem':
                    await this.handleItemMove(playerId, message);
                    break;

                case 'arrangeTiles':
                    await this.handleTileArrangement(playerId, message);
                    break;

                case 'connectEmojis':
                    await this.handleEmojiConnection(playerId, message);
                    break;

                case 'decodeCharacter':
                    await this.handleCipherDecode(playerId, message);
                    break;

                case 'mixColors':
                    await this.handleColorMix(playerId, message);
                    break;

                case 'requestGameState':
                    this.sendToPlayer(playerId, {
                        type: 'gameState',
                        gameState: this.gameState,
                        players: Array.from(this.players.values()),
                    });
                    break;

                default:
                    console.warn('Unknown message type:', message.type);
                    this.sendToPlayer(playerId, {
                        type: 'error',
                        message: `Unknown message type: ${message.type}`,
                    });
            }
        } catch (error) {
            const processingTime = Date.now() - startTime;
            this.logEvent('error', {
                playerId,
                messageType: message.type,
                error: error instanceof Error ? error.message : String(error),
                processingTime,
            });
            console.error('Error handling message:', error, {
                playerId,
                messageType: message.type,
                timestamp: Date.now(),
            });
            this.sendToPlayer(playerId, {
                type: 'error',
                message: 'An error occurred while processing your request',
            });
        } finally {
            const processingTime = Date.now() - startTime;
            if (processingTime > 100) {
                // Log slow requests
                this.logEvent('slow_request', {
                    playerId,
                    messageType: message.type,
                    processingTime,
                });
            }
        }
    }

    async startGame(config: GameConfig): Promise<void> {
        this.logEvent('game_starting', {
            gameType: config.gameType,
            linksCount: config.linksCount,
            playersCount: this.players.size,
        });

        // إذا كان هناك puzzle في config، استخدمه مباشرة
        let puzzle: Puzzle;
        if (config.puzzle) {
            puzzle = config.puzzle;
        } else {
            // في الإنتاج، يمكن جلب اللغز من KV أو قاعدة بيانات
            puzzle = await this.loadPuzzle(config);
        }

        // إضافة gameType إذا لم يكن موجوداً
        if (!puzzle.gameType) {
            puzzle.gameType = 'mysteryLink'; // default
        }

        this.gameState = {
            puzzle,
            gameType: puzzle.gameType,
            currentStep: 1,
            chosenNodes: [],
            score: 0,
            remainingSeconds: puzzle.timeLimit,
            startTime: Date.now(),
            currentPlayerIndex: 0,
            isGameStarted: true,
            isGameOver: false,
            gameSpecificData: this.initializeGameSpecificData(puzzle),
        };

        // بدء المؤقت
        this.startTimer();

        this.broadcast({
            type: 'gameStarted',
            gameState: this.gameState,
        });
    }

    private initializeGameSpecificData(puzzle: Puzzle): Record<string, any> {
        const gameType = puzzle.gameType || 'mysteryLink';

        switch (gameType) {
            case 'memoryFlip':
                return {
                    currentLevel: 1,
                    flippedCards: [],
                    matchedPairs: [],
                };
            case 'spotTheOdd':
                return {
                    currentRound: 1,
                    selectedItemId: null,
                };
            case 'shadowMatch':
                return {
                    currentRound: 1,
                    selectedItemId: null,
                };
            case 'spotTheChange':
                return {
                    currentRound: 1,
                    selectedItemId: null,
                };
            case 'sortSolve':
                return {
                    currentLevel: 1,
                    currentOrder: [],
                };
            case 'storyTiles':
                return {
                    currentChapter: 1,
                    currentOrder: [],
                };
            case 'puzzleSentence':
                return {
                    currentLevel: 1,
                    currentOrder: [],
                    sentence: '',
                };
            case 'emojiCircuit':
                return {
                    currentCircuit: 1,
                    connections: [],
                };
            case 'cipherTiles':
                return {
                    currentLevel: 1,
                    decodedWord: '',
                };
            case 'colorHarmony':
                return {
                    currentLevel: 1,
                    mixedColor1: null,
                    mixedColor2: null,
                };
            default:
                return {};
        }
    }

    async handleOptionSelection(playerId: string, message: ClientMessage): Promise<void> {
        if (!this.gameState || !this.gameState.isGameStarted || this.gameState.isGameOver) {
            this.sendToPlayer(playerId, {
                type: 'error',
                message: 'Game not started or already over',
            });
            return;
        }

        // التحقق من أن هذا هو دور اللاعب
        const playersArray = Array.from(this.players.values());
        const currentPlayer = playersArray[this.gameState.currentPlayerIndex];
        if (currentPlayer.id !== playerId) {
            this.sendToPlayer(playerId, {
                type: 'error',
                message: 'Not your turn',
            });
            return;
        }

        const { selectedNode, stepOrder } = message;
        const puzzle = this.gameState.puzzle!;
        const step = puzzle.steps[stepOrder - 1];

        if (!step) {
            this.sendToPlayer(playerId, {
                type: 'error',
                message: 'Invalid step',
            });
            return;
        }

        const correctOption = step.options.find((opt) => opt.isCorrect);
        const isCorrect = correctOption?.node.id === selectedNode.id;

        const player = this.players.get(playerId)!;

        if (isCorrect) {
            // إجابة صحيحة
            this.gameState.chosenNodes.push(selectedNode);
            this.gameState.currentStep++;

            // حساب النقاط
            const basePoints = 100;
            const multiplier = puzzle.linksCount;
            const stepScore = basePoints * multiplier;

            player.score += stepScore;
            player.correctAnswers++;
            this.players.set(playerId, player);

            // التحقق من انتهاء اللعبة
            if (this.gameState.currentStep > puzzle.linksCount) {
                this.gameState.isGameOver = true;
                this.stopTimer();

                this.broadcast({
                    type: 'gameCompleted',
                    gameState: this.gameState,
                    players: Array.from(this.players.values()),
                });
            } else {
                // الانتقال للاعب التالي
                this.gameState.currentPlayerIndex =
                    (this.gameState.currentPlayerIndex + 1) % playersArray.length;

                this.broadcast({
                    type: 'stepCompleted',
                    gameState: this.gameState,
                    players: Array.from(this.players.values()),
                    selectedNode,
                    isCorrect: true,
                });
            }
        } else {
            // إجابة خاطئة
            player.wrongAnswers++;
            this.players.set(playerId, player);

            // الانتقال للاعب التالي
            this.gameState.currentPlayerIndex =
                (this.gameState.currentPlayerIndex + 1) % playersArray.length;

            this.broadcast({
                type: 'wrongAnswer',
                gameState: this.gameState,
                players: Array.from(this.players.values()),
                playerId,
                selectedNode,
            });
        }
    }

    startTimer(): void {
        if (this.timerInterval) {
            clearInterval(this.timerInterval);
        }

        this.timerInterval = setInterval(() => {
            if (!this.gameState || !this.gameState.isGameStarted || this.gameState.isGameOver) {
                this.stopTimer();
                return;
            }

            this.gameState.remainingSeconds--;

            if (this.gameState.remainingSeconds <= 0) {
                this.gameState.isGameOver = true;
                this.stopTimer();

                this.broadcast({
                    type: 'gameTimeout',
                    gameState: this.gameState,
                    players: Array.from(this.players.values()),
                });
            } else {
                this.broadcast({
                    type: 'timerTick',
                    remainingSeconds: this.gameState.remainingSeconds,
                });
            }
        }, 1000) as unknown as number;
    }

    stopTimer(): void {
        if (this.timerInterval) {
            clearInterval(this.timerInterval);
            this.timerInterval = null;
        }
    }

    sendToPlayer(playerId: string, message: any): void {
        const ws = this.sessions.get(playerId);
        if (ws && ws.readyState === WebSocket.OPEN) {
            try {
                ws.send(JSON.stringify(message));
            } catch (e) {
                console.error('Error sending message to player:', e);
                // إزالة الاتصال الميت
                this.sessions.delete(playerId);
                this.players.delete(playerId);
            }
        } else {
            // إزالة الاتصال الميت
            this.sessions.delete(playerId);
            this.players.delete(playerId);
        }
    }

    private messageQueue: Array<{ message: any; excludePlayerId?: string }> = [];
    private batchTimer: number | null = null;
    private readonly BATCH_INTERVAL_MS = 100; // 100ms batching

    broadcast(message: any, excludePlayerId?: string): void {
        // إضافة الرسالة للـ queue
        this.messageQueue.push({ message, excludePlayerId });

        // بدء timer للـ batching إذا لم يكن موجوداً
        if (this.batchTimer === null) {
            this.batchTimer = setTimeout(() => {
                this.flushMessageQueue();
                this.batchTimer = null;
            }, this.BATCH_INTERVAL_MS) as unknown as number;
        }
    }

    private flushMessageQueue(): void {
        if (this.messageQueue.length === 0) return;

        const deadConnections: string[] = [];
        const messageStr = JSON.stringify(this.messageQueue.map(m => m.message));

        for (const [playerId, ws] of this.sessions.entries()) {
            const shouldExclude = this.messageQueue.some(m => m.excludePlayerId === playerId);
            if (!shouldExclude && ws.readyState === WebSocket.OPEN) {
                try {
                    // إرسال batch كرسالة واحدة
                    if (this.messageQueue.length === 1) {
                        ws.send(JSON.stringify(this.messageQueue[0].message));
                    } else {
                        ws.send(JSON.stringify({ type: 'batch', messages: this.messageQueue.map(m => m.message) }));
                    }
                } catch (e) {
                    console.error('Error broadcasting message:', e);
                    deadConnections.push(playerId);
                }
            } else if (!shouldExclude) {
                deadConnections.push(playerId);
            }
        }

        // تنظيف الاتصالات الميتة
        for (const playerId of deadConnections) {
            this.sessions.delete(playerId);
            this.players.delete(playerId);
        }

        // مسح الـ queue
        this.messageQueue = [];
    }

    async handleCardFlip(playerId: string, message: ClientMessage): Promise<void> {
        if (!this.gameState || !this.gameState.isGameStarted || this.gameState.isGameOver) {
            this.sendToPlayer(playerId, {
                type: 'error',
                message: 'Game not started or already over',
            });
            return;
        }

        const { cardId } = message;
        const gameType = this.gameState.gameType || 'mysteryLink';

        if (gameType !== 'memoryFlip') {
            this.sendToPlayer(playerId, {
                type: 'error',
                message: 'Invalid game type for this action',
            });
            return;
        }

        const gameData = this.gameState.gameSpecificData || {};
        const flippedCards = (gameData.flippedCards || []) as string[];
        const matchedPairs = (gameData.matchedPairs || []) as string[];

        if (flippedCards.includes(cardId) || matchedPairs.includes(cardId)) {
            this.sendToPlayer(playerId, {
                type: 'error',
                message: 'Card already flipped or matched',
            });
            return;
        }

        flippedCards.push(cardId);

        if (flippedCards.length === 2) {
            const puzzle = this.gameState.puzzle!;
            const cards = puzzle.gameTypeData?.cards || [];
            const card1 = cards.find((c: any) => c.id === flippedCards[0]);
            const card2 = cards.find((c: any) => c.id === flippedCards[1]);

            if (card1 && card2 && card1.pairId === card2.pairId) {
                matchedPairs.push(card1.pairId);
                flippedCards.length = 0;

                const player = this.players.get(playerId)!;
                player.score += 100;
                player.correctAnswers++;
                this.players.set(playerId, player);

                const totalPairs = cards.length / 2;
                const currentLevel = (gameData.currentLevel as number) || 1;
                let newLevel = currentLevel;
                let isGameComplete = false;

                if (matchedPairs.length >= totalPairs) {
                    if (currentLevel < puzzle.linksCount) {
                        newLevel = currentLevel + 1;
                        // إعادة تعيين للمستوى الجديد
                        matchedPairs.length = 0;
                        flippedCards.length = 0;
                    } else {
                        isGameComplete = true;
                        this.gameState.isGameOver = true;
                        this.stopTimer();
                    }
                }

                this.gameState.gameSpecificData = {
                    ...gameData,
                    currentLevel: newLevel,
                    flippedCards,
                    matchedPairs,
                };

                if (isGameComplete) {
                    this.broadcast({
                        type: 'gameCompleted',
                        gameState: this.gameState,
                        players: Array.from(this.players.values()),
                    });
                    await this.saveStateToKV();
                } else {
                    await this.periodicSnapshot();
                }
            } else {
                setTimeout(() => {
                    if (this.gameState) {
                        const gameData = this.gameState.gameSpecificData || {};
                        (gameData.flippedCards as string[]).length = 0;
                        this.broadcast({
                            type: 'cardsReset',
                            gameState: this.gameState,
                        });
                    }
                }, 1000);
            }
        }

        if (flippedCards.length < 2) {
            this.gameState.gameSpecificData = {
                ...gameData,
                flippedCards,
                matchedPairs,
            };
        }

        this.broadcast({
            type: 'cardFlipped',
            playerId,
            cardId,
            gameState: this.gameState,
            players: Array.from(this.players.values()),
        });
    }

    async handleItemSelection(playerId: string, message: ClientMessage): Promise<void> {
        if (!this.gameState || !this.gameState.isGameStarted || this.gameState.isGameOver) {
            this.sendToPlayer(playerId, {
                type: 'error',
                message: 'Game not started or already over',
            });
            return;
        }

        const { itemId } = message;
        const gameType = this.gameState.gameType || 'mysteryLink';

        if (!['spotTheOdd', 'shadowMatch', 'spotTheChange'].includes(gameType)) {
            this.sendToPlayer(playerId, {
                type: 'error',
                message: 'Invalid game type for this action',
            });
            return;
        }

        const puzzle = this.gameState.puzzle!;
        const gameData = this.gameState.gameSpecificData || {};
        const correctAnswer = puzzle.gameTypeData?.correctAnswer ||
            puzzle.gameTypeData?.shadows?.find((s: any) => s.isCorrect)?.id ||
            puzzle.gameTypeData?.options?.find((o: any) => o.isCorrect)?.id;

        const isCorrect = itemId === correctAnswer;
        const currentRound = (gameData.currentRound as number) || 1;
        let newRound = currentRound;
        let isGameComplete = false;

        const player = this.players.get(playerId)!;
        if (isCorrect) {
            if (currentRound < puzzle.linksCount) {
                newRound = currentRound + 1;
            } else {
                isGameComplete = true;
                this.gameState.isGameOver = true;
                this.stopTimer();
            }

            const basePoints = 100;
            const multiplier = puzzle.linksCount;
            player.score += basePoints * multiplier;
            player.correctAnswers++;
        } else {
            player.wrongAnswers++;
            player.score = Math.max(0, player.score - 50);
        }
        this.players.set(playerId, player);

        this.gameState.gameSpecificData = {
            ...gameData,
            currentRound: newRound,
            selectedItemId: itemId,
        };

        this.broadcast({
            type: 'itemSelected',
            playerId,
            itemId,
            isCorrect,
            gameState: this.gameState,
            players: Array.from(this.players.values()),
        });

        if (isGameComplete) {
            this.broadcast({
                type: 'gameCompleted',
                gameState: this.gameState,
                players: Array.from(this.players.values()),
            });
            await this.saveStateToKV();
        } else {
            await this.periodicSnapshot();
        }
    }

    async handleItemMove(playerId: string, message: ClientMessage): Promise<void> {
        if (!this.gameState || !this.gameState.isGameStarted || this.gameState.isGameOver) {
            this.sendToPlayer(playerId, {
                type: 'error',
                message: 'Game not started or already over',
            });
            return;
        }

        const { itemId, newPosition } = message;
        const gameType = this.gameState.gameType || 'mysteryLink';

        if (!['sortSolve', 'storyTiles', 'puzzleSentence'].includes(gameType)) {
            this.sendToPlayer(playerId, {
                type: 'error',
                message: 'Invalid game type for this action',
            });
            return;
        }

        const gameData = this.gameState.gameSpecificData || {};
        const currentOrder = (gameData.currentOrder || []) as string[];
        const currentLevel = (gameData.currentLevel as number) || (gameData.currentChapter as number) || 1;
        const levelKey = gameType === 'storyTiles' ? 'currentChapter' : 'currentLevel';

        const updatedOrder = [...currentOrder];
        const index = updatedOrder.indexOf(itemId);
        if (index !== -1) {
            updatedOrder.splice(index, 1);
        }
        updatedOrder.splice(newPosition, 0, itemId);

        // التحقق من الترتيب الصحيح
        const puzzle = this.gameState.puzzle!;
        const items = (puzzle.gameTypeData?.items || puzzle.gameTypeData?.tiles || puzzle.gameTypeData?.words || []) as Array<any>;
        const sortedItems = [...items].sort((a: any, b: any) => {
            const orderA = a.order || 0;
            const orderB = b.order || 0;
            return orderA - orderB;
        });
        const correctOrder = sortedItems.map((item: any) => item.id);
        const isCorrect = JSON.stringify(updatedOrder) === JSON.stringify(correctOrder);

        let newLevel = currentLevel;
        let isGameComplete = false;

        if (isCorrect) {
            if (currentLevel < puzzle.linksCount) {
                newLevel = currentLevel + 1;
                // إعادة تعيين للمستوى الجديد
                updatedOrder.length = 0;
            } else {
                isGameComplete = true;
                this.gameState.isGameOver = true;
                this.stopTimer();
            }

            const player = this.players.get(playerId)!;
            const basePoints = 100;
            const multiplier = puzzle.linksCount;
            player.score += basePoints * multiplier;
            player.correctAnswers++;
            this.players.set(playerId, player);
        }

        this.gameState.gameSpecificData = {
            ...gameData,
            [levelKey]: newLevel,
            currentOrder: updatedOrder,
        };

        this.broadcast({
            type: 'itemMoved',
            playerId,
            itemId,
            newPosition,
            isCorrect,
            gameState: this.gameState,
            players: Array.from(this.players.values()),
        });

        if (isGameComplete) {
            this.broadcast({
                type: 'gameCompleted',
                gameState: this.gameState,
                players: Array.from(this.players.values()),
            });
            await this.saveStateToKV();
        } else {
            await this.periodicSnapshot();
        }
    }

    async handleTileArrangement(playerId: string, message: ClientMessage): Promise<void> {
        await this.handleItemMove(playerId, message);
    }

    async handleEmojiConnection(playerId: string, message: ClientMessage): Promise<void> {
        if (!this.gameState || !this.gameState.isGameStarted || this.gameState.isGameOver) {
            this.sendToPlayer(playerId, {
                type: 'error',
                message: 'Game not started or already over',
            });
            return;
        }

        const { emojiId, nextEmojiId } = message;
        const gameType = this.gameState.gameType || 'mysteryLink';

        if (gameType !== 'emojiCircuit') {
            this.sendToPlayer(playerId, {
                type: 'error',
                message: 'Invalid game type for this action',
            });
            return;
        }

        try {
            const puzzle = this.gameState.puzzle!;
            const gameData = this.gameState.gameSpecificData || {};
            const connections = (gameData.connections || []) as Array<{ from: string; to: string }>;
            const currentCircuit = (gameData.currentCircuit as number) || 1;

            // إضافة الاتصال
            const newConnection = { from: emojiId, to: nextEmojiId };
            let updatedConnections = [...connections, newConnection];

            // التحقق من صحة الاتصال (يمكن توسيعه)
            const rule = puzzle.gameTypeData?.rule as string | undefined;
            const isCorrect = this.validateEmojiConnection(emojiId, nextEmojiId, puzzle, rule);

            let newCircuit = currentCircuit;
            let isGameComplete = false;

            if (isCorrect) {
                // التحقق من اكتمال الدائرة
                const emojis = puzzle.gameTypeData?.emojis as Array<any> | undefined;
                if (emojis) {
                    const circuitEmojis = this.getCircuitEmojis(puzzle, currentCircuit);
                    const isCircuitComplete = updatedConnections.length >= (circuitEmojis.length - 1);

                    if (isCircuitComplete) {
                        if (currentCircuit < puzzle.linksCount) {
                            newCircuit = currentCircuit + 1;
                            updatedConnections = []; // إعادة تعيين للدائرة الجديدة
                        } else {
                            isGameComplete = true;
                        }
                    }
                }

                const player = this.players.get(playerId)!;
                const basePoints = 100;
                const multiplier = puzzle.linksCount;
                player.score += basePoints * multiplier;
                player.correctAnswers++;
                this.players.set(playerId, player);

                if (isGameComplete) {
                    this.gameState.isGameOver = true;
                    this.stopTimer();
                }
            } else {
                const player = this.players.get(playerId)!;
                player.wrongAnswers++;
                player.score = Math.max(0, player.score - 50);
                this.players.set(playerId, player);
            }

            this.gameState.gameSpecificData = {
                ...gameData,
                currentCircuit: newCircuit,
                connections: updatedConnections,
            };

            this.broadcast({
                type: 'emojiConnected',
                playerId,
                emojiId,
                nextEmojiId,
                isCorrect,
                gameState: this.gameState,
                players: Array.from(this.players.values()),
            });

            if (isGameComplete) {
                this.broadcast({
                    type: 'gameCompleted',
                    gameState: this.gameState,
                    players: Array.from(this.players.values()),
                });
                await this.saveStateToKV(); // حفظ الحالة النهائية
            } else {
                await this.periodicSnapshot(); // حفظ دوري
            }
        } catch (error) {
            console.error('Error handling emoji connection:', error);
            this.sendToPlayer(playerId, {
                type: 'error',
                message: 'Failed to process emoji connection',
            });
        }
    }

    async handleCipherDecode(playerId: string, message: ClientMessage): Promise<void> {
        if (!this.gameState || !this.gameState.isGameStarted || this.gameState.isGameOver) {
            this.sendToPlayer(playerId, {
                type: 'error',
                message: 'Game not started or already over',
            });
            return;
        }

        const { tileId, decodedChar } = message;
        const gameType = this.gameState.gameType || 'mysteryLink';

        if (gameType !== 'cipherTiles') {
            this.sendToPlayer(playerId, {
                type: 'error',
                message: 'Invalid game type for this action',
            });
            return;
        }

        try {
            const puzzle = this.gameState.puzzle!;
            const gameData = this.gameState.gameSpecificData || {};
            let decodedWord = (gameData.decodedWord as string) || '';
            const currentLevel = (gameData.currentLevel as number) || 1;

            // إضافة الحرف للكلمة
            decodedWord += decodedChar;

            // الحصول على الكلمة الصحيحة للمستوى الحالي
            const correctWord = this.getLevelWord(puzzle, currentLevel);
            if (!correctWord) {
                this.sendToPlayer(playerId, {
                    type: 'error',
                    message: 'No correct word found for current level',
                });
                return;
            }

            const isCorrect = decodedWord === correctWord;
            let newLevel = currentLevel;
            let isGameComplete = false;

            if (isCorrect) {
                if (currentLevel < puzzle.linksCount) {
                    newLevel = currentLevel + 1;
                    decodedWord = ''; // إعادة تعيين للمستوى الجديد
                } else {
                    isGameComplete = true;
                }

                const player = this.players.get(playerId)!;
                const basePoints = 100;
                const multiplier = puzzle.linksCount;
                player.score += basePoints * multiplier * 4; // مكافأة عالية للشفرة
                player.correctAnswers++;
                this.players.set(playerId, player);

                if (isGameComplete) {
                    this.gameState.isGameOver = true;
                    this.stopTimer();
                }
            } else if (decodedWord.length > correctWord.length || !correctWord.startsWith(decodedWord)) {
                const player = this.players.get(playerId)!;
                player.wrongAnswers++;
                player.score = Math.max(0, player.score - 50);
                this.players.set(playerId, player);
            }

            this.gameState.gameSpecificData = {
                ...gameData,
                currentLevel: newLevel,
                decodedWord,
            };

            this.broadcast({
                type: 'cipherDecoded',
                playerId,
                tileId,
                decodedChar,
                decodedWord,
                isCorrect,
                gameState: this.gameState,
                players: Array.from(this.players.values()),
            });

            if (isGameComplete) {
                this.broadcast({
                    type: 'gameCompleted',
                    gameState: this.gameState,
                    players: Array.from(this.players.values()),
                });
            }
        } catch (error) {
            console.error('Error handling cipher decode:', error);
            this.sendToPlayer(playerId, {
                type: 'error',
                message: 'Failed to process cipher decode',
            });
        }
    }

    async handleColorMix(playerId: string, message: ClientMessage): Promise<void> {
        if (!this.gameState || !this.gameState.isGameStarted || this.gameState.isGameOver) {
            this.sendToPlayer(playerId, {
                type: 'error',
                message: 'Game not started or already over',
            });
            return;
        }

        const { color1Id, color2Id } = message;
        const gameType = this.gameState.gameType || 'mysteryLink';

        if (gameType !== 'colorHarmony') {
            this.sendToPlayer(playerId, {
                type: 'error',
                message: 'Invalid game type for this action',
            });
            return;
        }

        try {
            const puzzle = this.gameState.puzzle!;
            const gameData = this.gameState.gameSpecificData || {};
            const currentLevel = (gameData.currentLevel as number) || 1;

            // التحقق من صحة المزج
            const mixRule = puzzle.gameTypeData?.mixRule as string | undefined;
            const isCorrect = this.validateColorMix(color1Id, color2Id, mixRule, puzzle);

            let newLevel = currentLevel;
            let isGameComplete = false;

            if (isCorrect) {
                if (currentLevel < puzzle.linksCount) {
                    newLevel = currentLevel + 1;
                } else {
                    isGameComplete = true;
                }

                const player = this.players.get(playerId)!;
                const basePoints = 100;
                const multiplier = puzzle.linksCount;
                player.score += basePoints * multiplier * 3;
                player.correctAnswers++;
                this.players.set(playerId, player);

                if (isGameComplete) {
                    this.gameState.isGameOver = true;
                    this.stopTimer();
                }
            } else {
                const player = this.players.get(playerId)!;
                player.wrongAnswers++;
                player.score = Math.max(0, player.score - 50);
                this.players.set(playerId, player);
            }

            this.gameState.gameSpecificData = {
                ...gameData,
                currentLevel: newLevel,
                mixedColor1: color1Id,
                mixedColor2: color2Id,
            };

            this.broadcast({
                type: 'colorMixed',
                playerId,
                color1Id,
                color2Id,
                isCorrect,
                gameState: this.gameState,
                players: Array.from(this.players.values()),
            });

            if (isGameComplete) {
                this.broadcast({
                    type: 'gameCompleted',
                    gameState: this.gameState,
                    players: Array.from(this.players.values()),
                });
                await this.saveStateToKV();
            } else {
                await this.periodicSnapshot();
            }
        } catch (error) {
            console.error('Error handling color mix:', error);
            this.sendToPlayer(playerId, {
                type: 'error',
                message: 'Failed to process color mix',
            });
        }
    }

    // Helper methods
    validateEmojiConnection(emojiId1: string, emojiId2: string, puzzle: Puzzle, rule?: string): boolean {
        // منطق بسيط: يمكن توسيعه حسب القواعد المختلفة
        return true;
    }

    getCircuitEmojis(puzzle: Puzzle, circuit: number): Array<any> {
        const allEmojis = puzzle.gameTypeData?.emojis as Array<any> | undefined;
        if (!allEmojis) return [];

        if (puzzle.steps && puzzle.steps.length > 0 && circuit <= puzzle.steps.length) {
            const step = puzzle.steps[circuit - 1];
            return step.options.map(opt => ({
                id: opt.node.id,
                label: opt.node.label,
            }));
        }

        const emojisPerCircuit = Math.ceil(allEmojis.length / puzzle.linksCount);
        const startIndex = (circuit - 1) * emojisPerCircuit;
        const endIndex = Math.min(startIndex + emojisPerCircuit, allEmojis.length);

        return allEmojis.slice(startIndex, endIndex);
    }

    getLevelWord(puzzle: Puzzle, level: number): string | null {
        if (puzzle.steps && puzzle.steps.length > 0 && level <= puzzle.steps.length) {
            const step = puzzle.steps[level - 1];
            return step.options.map(opt => opt.node.label).join(' ');
        }

        const allWords = puzzle.gameTypeData?.words as Array<any> | undefined;
        if (allWords && level <= allWords.length) {
            return (allWords[level - 1] as any)?.word || null;
        }

        return (puzzle.gameTypeData?.decodedWord as string) || null;
    }

    validateColorMix(color1Id: string, color2Id: string, mixRule?: string, puzzle?: Puzzle): boolean {
        if (!mixRule || !puzzle) return true;

        const colors = puzzle.gameTypeData?.colors as Array<any> | undefined;
        if (!colors) return false;

        const color1 = colors.find((c: any) => c.id === color1Id);
        const color2 = colors.find((c: any) => c.id === color2Id);

        if (!color1 || !color2) return false;

        const ruleParts = mixRule.split('_');
        if (ruleParts.length === 2) {
            const color1Label = ((color1.label as string) || '').toLowerCase();
            const color2Label = ((color2.label as string) || '').toLowerCase();
            return (
                (color1Label.includes(ruleParts[0]) && color2Label.includes(ruleParts[1])) ||
                (color1Label.includes(ruleParts[1]) && color2Label.includes(ruleParts[0]))
            );
        }

        return true;
    }

    async loadPuzzle(config: GameConfig): Promise<Puzzle> {
        // TODO: في الإنتاج، جلب اللغز من:
        // 1. Cloudflare KV (Key-Value store)
        // 2. قاعدة بيانات خارجية
        // 3. Flutter app يرسل اللغز كاملاً عند بدء اللعبة

        // للآن، سنعيد puzzle بسيط للاختبار
        // في الإنتاج، يجب جلب اللغز الفعلي بناءً على config
        return {
            id: config.puzzleId || 'test-puzzle',
            type: config.representationType,
            category: config.category,
            start: {
                id: 'start',
                label: 'Start',
                representationType: config.representationType,
            },
            end: {
                id: 'end',
                label: 'End',
                representationType: config.representationType,
            },
            linksCount: config.linksCount,
            timeLimit: 120,
            steps: [], // سيتم إرسالها من Flutter
        };
    }

    generateId(): string {
        return Math.random().toString(36).substring(2, 15);
    }

    // Data Persistence Methods
    private _lastSnapshotTime = 0;
    private readonly SNAPSHOT_INTERVAL_MS = 30000; // 30 seconds

    async saveStateToKV(): Promise<void> {
        if (!this.env.GAME_STATE_KV || !this.gameState) return;

        try {
            const roomId = this.state.id.toString();
            const stateData = {
                gameState: this.gameState,
                players: Array.from(this.players.values()),
                timestamp: Date.now(),
            };

            await this.env.GAME_STATE_KV.put(
                `room:${roomId}`,
                JSON.stringify(stateData),
                { expirationTtl: 3600 } // 1 hour TTL
            );

            console.log(`[KV] Saved game state for room ${roomId}`);
        } catch (error) {
            console.error('[KV] Error saving game state:', error);
        }
    }

    async periodicSnapshot(): Promise<void> {
        const now = Date.now();
        if (now - this._lastSnapshotTime < this.SNAPSHOT_INTERVAL_MS) {
            return; // Too soon for another snapshot
        }

        this._lastSnapshotTime = now;
        await this.saveStateToKV();
    }

    async loadStateFromKV(): Promise<void> {
        if (!this.env.GAME_STATE_KV) return;

        try {
            const roomId = this.state.id.toString();
            const stateData = await this.env.GAME_STATE_KV.get(`room:${roomId}`);

            if (stateData) {
                const parsed = JSON.parse(stateData);
                this.gameState = parsed.gameState;
                this.players = new Map(
                    parsed.players.map((p: PlayerInfo) => [p.id, p])
                );
                console.log(`[KV] Loaded game state for room ${roomId}`);
            }
        } catch (error) {
            console.error('[KV] Error loading game state:', error);
        }
    }
}

async function verifyJwt(token: string, secret: string): Promise<JwtPayload | null> {
    const segments = token.split('.');
    if (segments.length !== 3) {
        return null;
    }

    const [encodedHeader, encodedPayload, encodedSignature] = segments;
    const headerJson = base64UrlToString(encodedHeader);
    const payloadJson = base64UrlToString(encodedPayload);

    let header: JwtHeader;
    try {
        header = JSON.parse(headerJson) as JwtHeader;
    } catch {
        return null;
    }

    if (!header.alg || header.alg.toUpperCase() !== 'HS256') {
        return null;
    }

    const key = await crypto.subtle.importKey(
        'raw',
        textEncoder.encode(secret),
        { name: 'HMAC', hash: 'SHA-256' },
        false,
        ['verify']
    );

    const data = textEncoder.encode(`${encodedHeader}.${encodedPayload}`);
    const signature = base64UrlToUint8Array(encodedSignature);
    const isValid = await crypto.subtle.verify('HMAC', key, signature.buffer as ArrayBuffer, data);
    if (!isValid) {
        return null;
    }

    try {
        return JSON.parse(payloadJson) as JwtPayload;
    } catch {
        return null;
    }
}

function base64UrlToString(value: string): string {
    return textDecoder.decode(base64UrlToUint8Array(value));
}

function base64UrlToUint8Array(value: string): Uint8Array {
    const normalized = value.replace(/-/g, '+').replace(/_/g, '/');
    const padded = normalized + '='.repeat((4 - (normalized.length % 4)) % 4);
    const binary = atob(padded);
    const bytes = new Uint8Array(binary.length);
    for (let i = 0; i < binary.length; i += 1) {
        bytes[i] = binary.charCodeAt(i);
    }
    return bytes;
}

