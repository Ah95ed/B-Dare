import { Env } from './index';

// Extend Env interface
interface ExtendedEnv extends Env {
  TOURNAMENT_KV?: KVNamespace;
  ENVIRONMENT?: string;
}

interface Tournament {
  id: string;
  name: string;
  description?: string;
  type: 'singleElimination' | 'doubleElimination' | 'swiss' | 'roundRobin';
  status: 'registration' | 'qualifiers' | 'playoffs' | 'finalStage' | 'completed' | 'cancelled';
  startDate: number;
  endDate: number;
  registrationStartDate: number;
  registrationEndDate: number;
  maxTeams: number;
  currentTeams: number;
  settings: TournamentSettings;
  prizePool?: string;
  organizerId?: string;
}

interface TournamentSettings {
  maxTeams: number;
  minTeamsPerMatch: number;
  maxTeamsPerMatch: number;
  matchDuration: number; // seconds
  breakBetweenMatches: number; // seconds
  allowRescheduling: boolean;
  reschedulingDeadlineHours: number;
  autoForfeitEnabled: boolean;
  autoForfeitMinutes: number;
}

interface Team {
  id: string;
  name: string;
  captainId: string;
  memberIds: string[];
  timeZone: string;
  preferredTimeSlots: number[];
  stats: TeamStats;
  seed?: number;
  avatarUrl?: string;
  countryCode?: string;
  registeredAt: number;
}

interface TeamStats {
  matchesPlayed: number;
  matchesWon: number;
  matchesLost: number;
  totalScore: number;
  winRate: number;
  currentStreak: number;
  isWinningStreak: boolean;
}

interface Match {
  id: string;
  tournamentId: string;
  stageId: string;
  team1: Team;
  team2: Team;
  status: 'scheduled' | 'inProgress' | 'completed' | 'forfeited' | 'cancelled';
  scheduledTime: number;
  startTime?: number;
  endTime?: number;
  gameResults: GameResult[];
  winner?: Team;
  format: 'bestOf3' | 'bestOf5' | 'bestOf7' | 'singleGame';
  roomId?: string;
  timeZone?: string;
  preferredTimeSlots?: number[];
  isRescheduled: boolean;
  rescheduleReason?: string;
}

interface GameResult {
  gameNumber: number;
  winnerTeamId?: string;
  team1Score: number;
  team2Score: number;
  duration: number; // seconds
  completedAt: number;
}

interface TournamentStage {
  id: string;
  tournamentId: string;
  name: string;
  type: 'qualifier' | 'elimination' | 'finalStage';
  status: 'notStarted' | 'inProgress' | 'completed';
  roundNumber: number;
  totalRounds: number;
  matches: Match[];
  startDate: number;
  endDate: number;
  format: 'bestOf3' | 'bestOf5' | 'bestOf7' | 'singleGame';
  teamsAdvancing?: number;
}

interface ClientMessage {
  type: string;
  [key: string]: any;
}

interface TournamentSnapshot {
  tournament: Tournament | null;
  teams: Team[];
  stages: TournamentStage[];
  matches: Match[];
  bracket: Record<string, unknown> | null;
}

interface TournamentIndexRecord extends Tournament {
  updatedAt: number;
}

export class TournamentRoom implements DurableObject {
  private state: DurableObjectState;
  private env: ExtendedEnv;
  private tournament: Tournament | null = null;
  private teams: Map<string, Team> = new Map();
  private stages: Map<string, TournamentStage> = new Map();
  private matches: Map<string, Match> = new Map();
  private bracket: Record<string, unknown> | null = null;
  private sockets: Set<WebSocket> = new Set();
  private readonly storageKey = 'tournamentState';
  private readonly snapshotTtlSeconds = 3600;
  private readonly ready: Promise<void>;

  constructor(state: DurableObjectState, env: ExtendedEnv) {
    this.state = state;
    this.env = env;
    this.ready = this.state.blockConcurrencyWhile(async () => {
      await this.loadStateFromStorage();
    });
  }

  async fetch(request: Request): Promise<Response> {
    await this.ready;
    const url = new URL(request.url);

    const corsResult = buildCorsHeaders(request, this.env);
    if ('response' in corsResult) {
      return corsResult.response;
    }
    const corsHeaders = corsResult.headers;

    if (request.method === 'OPTIONS') {
      return new Response(null, { headers: corsHeaders });
    }

    // WebSocket upgrade
    if (url.pathname.endsWith('/ws')) {
      const upgradeHeader = request.headers.get('Upgrade');
      if (upgradeHeader !== 'websocket') {
        return new Response('Expected WebSocket', { status: 400 });
      }

      if (!isOriginAllowed(request, this.env)) {
        return new Response('Forbidden', { status: 403 });
      }

      const pair = new WebSocketPair();
      const client = pair[0];
      const server = pair[1];

      this.acceptWebSocket(server);

      return new Response(null, {
        status: 101,
        webSocket: client,
        headers: corsHeaders,
      });
    }

    // REST API
    const rawPath = url.pathname.split('/').filter(Boolean);
    let path = normalizeTournamentPath(rawPath);
    if (path.length === 0) {
      path = ['tournament'];
    }

    try {
      if (path[0] === 'tournament') {
        if (request.method === 'GET') {
          return this.handleGetTournament(corsHeaders);
        } else if (request.method === 'POST') {
          const body = await request.json();
          return this.handleCreateTournament(body, corsHeaders);
        } else if (request.method === 'PUT') {
          const body = await request.json();
          return this.handleUpdateTournament(body, corsHeaders);
        }
      } else if (path[0] === 'teams') {
        if (request.method === 'GET') {
          return this.handleGetTeams(corsHeaders);
        } else if (request.method === 'POST') {
          const body = await request.json();
          return this.handleRegisterTeam(body, corsHeaders);
        } else if (request.method === 'DELETE' && path[1]) {
          return this.handleUnregisterTeam(path[1], corsHeaders);
        }
      } else if (path[0] === 'stages') {
        if (request.method === 'GET') {
          return this.handleGetStages(corsHeaders);
        } else if (request.method === 'POST') {
          const body = await request.json();
          return this.handleCreateStage(body, corsHeaders);
        } else if (request.method === 'PUT' && path[1]) {
          const body = await request.json();
          return this.handleUpdateStage(path[1], body, corsHeaders);
        }
      } else if (path[0] === 'matches') {
        if (request.method === 'GET' && path[1]) {
          return this.handleGetMatch(path[1], corsHeaders);
        } else if (request.method === 'POST' && path[1] && path[2] === 'start') {
          return this.handleStartMatch(path[1], request, corsHeaders);
        } else if (request.method === 'POST') {
          const body = await request.json();
          return this.handleCreateMatch(body, corsHeaders);
        } else if (request.method === 'PUT' && path[1]) {
          const body = await request.json();
          return this.handleUpdateMatch(path[1], body, corsHeaders);
        }
      } else if (path[0] === 'bracket') {
        if (request.method === 'GET') {
          return this.handleGetBracket(corsHeaders);
        } else if (request.method === 'PUT') {
          const body = await request.json();
          return this.handleSaveBracket(body, corsHeaders);
        }
      }

      return new Response('Not Found', { status: 404, headers: corsHeaders });
    } catch (error) {
      logInternalError('TournamentRoom fetch error', error);
      return new Response(
        JSON.stringify({ error: 'Internal Server Error' }),
        {
          status: 500,
          headers: { ...corsHeaders, 'Content-Type': 'application/json' },
        }
      );
    }
  }

  // Tournament handlers
  private handleGetTournament(corsHeaders: Record<string, string>): Response {
    if (!this.tournament) {
      return new Response(
        JSON.stringify({ error: 'Tournament not found' }),
        { status: 404, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      );
    }

    return new Response(
      JSON.stringify({
        ...this.tournament,
        teams: Array.from(this.teams.values()),
        stages: Array.from(this.stages.values()),
      }),
      { headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    );
  }

  private async handleCreateTournament(
    body: any,
    corsHeaders: Record<string, string>
  ): Promise<Response> {
    const tournamentData = body as Tournament;
    const tournamentId = this.state.id.toString();
    this.tournament = {
      ...tournamentData,
      id: tournamentId,
      currentTeams: this.teams.size,
    };
    await this.persistState('tournamentCreated');
    this.broadcastTournamentUpdate('tournamentCreated');
    return new Response(
      JSON.stringify(this.tournament),
      { status: 201, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    );
  }

  private async handleUpdateTournament(
    body: any,
    corsHeaders: Record<string, string>
  ): Promise<Response> {
    if (!this.tournament) {
      return new Response(
        JSON.stringify({ error: 'Tournament not found' }),
        { status: 404, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      );
    }

    this.tournament = { ...this.tournament, ...body };
    await this.persistState('tournamentUpdated');
    this.broadcastTournamentUpdate('tournamentUpdated');
    return new Response(
      JSON.stringify(this.tournament),
      { headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    );
  }

  // Team handlers
  private handleGetTeams(corsHeaders: Record<string, string>): Response {
    return new Response(
      JSON.stringify({ teams: Array.from(this.teams.values()) }),
      { headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    );
  }

  private async handleRegisterTeam(
    body: any,
    corsHeaders: Record<string, string>
  ): Promise<Response> {
    const team = body as Team;
    this.teams.set(team.id, team);
    
    if (this.tournament) {
      this.tournament.currentTeams = this.teams.size;
    }

    await this.persistState('teamRegistered');
    this.broadcastTournamentUpdate('teamRegistered');

    return new Response(
      JSON.stringify(team),
      { status: 201, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    );
  }

  private async handleUnregisterTeam(
    teamId: string,
    corsHeaders: Record<string, string>
  ): Promise<Response> {
    this.teams.delete(teamId);
    
    if (this.tournament) {
      this.tournament.currentTeams = this.teams.size;
    }

    await this.persistState('teamUnregistered');
    this.broadcastTournamentUpdate('teamUnregistered');

    return new Response(null, { status: 204, headers: corsHeaders });
  }

  // Stage handlers
  private handleGetStages(corsHeaders: Record<string, string>): Response {
    return new Response(
      JSON.stringify({ stages: Array.from(this.stages.values()) }),
      { headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    );
  }

  private async handleCreateStage(
    body: any,
    corsHeaders: Record<string, string>
  ): Promise<Response> {
    const stage = body as TournamentStage;
    this.stages.set(stage.id, stage);
    await this.persistState('stageCreated');
    this.broadcastTournamentUpdate('stageCreated');
    return new Response(
      JSON.stringify(stage),
      { status: 201, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    );
  }

  private async handleUpdateStage(
    stageId: string,
    body: any,
    corsHeaders: Record<string, string>
  ): Promise<Response> {
    const stage = this.stages.get(stageId);
    if (!stage) {
      return new Response(
        JSON.stringify({ error: 'Stage not found' }),
        { status: 404, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      );
    }

    const updated = { ...stage, ...body };
    this.stages.set(stageId, updated);
    await this.persistState('stageUpdated');
    this.broadcastTournamentUpdate('stageUpdated');
    return new Response(
      JSON.stringify(updated),
      { headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    );
  }

  // Match handlers
  private handleGetMatch(
    matchId: string,
    corsHeaders: Record<string, string>
  ): Response {
    const match = this.matches.get(matchId);
    if (!match) {
      return new Response(
        JSON.stringify({ error: 'Match not found' }),
        { status: 404, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      );
    }

    return new Response(
      JSON.stringify(match),
      { headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    );
  }

  private async handleCreateMatch(
    body: any,
    corsHeaders: Record<string, string>
  ): Promise<Response> {
    const match = body as Match;
    this.matches.set(match.id, match);
    await this.persistState('matchCreated');
    this.broadcastTournamentUpdate('matchCreated');
    return new Response(
      JSON.stringify(match),
      { status: 201, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    );
  }

  private async handleUpdateMatch(
    matchId: string,
    body: any,
    corsHeaders: Record<string, string>
  ): Promise<Response> {
    const match = this.matches.get(matchId);
    if (!match) {
      return new Response(
        JSON.stringify({ error: 'Match not found' }),
        { status: 404, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      );
    }

    const updated = { ...match, ...body };
    this.matches.set(matchId, updated);
    await this.persistState('matchUpdated');
    this.broadcastTournamentUpdate('matchUpdated');
    return new Response(
      JSON.stringify(updated),
      { headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    );
  }

  private async handleStartMatch(
    matchId: string,
    request: Request,
    corsHeaders: Record<string, string>
  ): Promise<Response> {
    const match = this.matches.get(matchId);
    if (!match) {
      return new Response(
        JSON.stringify({ error: 'Match not found' }),
        { status: 404, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      );
    }

    if (match.status !== 'scheduled') {
      return new Response(
        JSON.stringify({ error: 'Match cannot be started. Current status: ' + match.status }),
        { status: 400, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      );
    }

    const gameRoomId = `match_${matchId}`;
    match.roomId = gameRoomId;
    match.status = 'inProgress';
    match.startTime = Date.now();
    
    this.matches.set(matchId, match);

    await this.persistState('matchStarted');
    this.broadcastTournamentUpdate('matchStarted');

    const requestUrl = new URL(request.url);
    const protocol = requestUrl.protocol === 'https:' ? 'wss' : 'ws';

    return new Response(
      JSON.stringify({
        ...match,
        roomId: gameRoomId,
        wsUrl: `${protocol}://${requestUrl.host}/game/${gameRoomId}`,
      }),
      { headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    );
  }

  // Bracket handlers
  private handleGetBracket(corsHeaders: Record<string, string>): Response {
    if (!this.bracket) {
      return new Response(
        JSON.stringify({ error: 'Bracket not configured' }),
        { status: 404, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      );
    }

    return new Response(
      JSON.stringify({ bracket: this.bracket }),
      { headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    );
  }

  private async handleSaveBracket(
    body: any,
    corsHeaders: Record<string, string>
  ): Promise<Response> {
    this.bracket = body as Record<string, unknown>;
    await this.persistState('bracketUpdated');
    this.broadcastTournamentUpdate('bracketUpdated');
    return new Response(
      JSON.stringify({ message: 'Bracket saved', bracket: this.bracket }),
      { headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    );
  }

  // WebSocket handling
  private acceptWebSocket(ws: WebSocket): void {
    ws.accept();
    this.sockets.add(ws);
    ws.send(JSON.stringify({ type: 'snapshot', data: this.buildSnapshot() }));

    ws.addEventListener('message', (event) => {
      try {
        const message = JSON.parse(event.data as string) as ClientMessage;
        this.handleWebSocketMessage(ws, message);
      } catch (error) {
        logInternalError('TournamentRoom WS parse error', error);
        ws.send(JSON.stringify({ type: 'error', message: 'Invalid message format' }));
      }
    });

    const cleanup = (): void => {
      this.sockets.delete(ws);
    };

    ws.addEventListener('close', cleanup);
    ws.addEventListener('error', cleanup);
  }

  private handleWebSocketMessage(ws: WebSocket, message: ClientMessage): void {
    switch (message.type) {
      case 'subscribe':
      case 'sync':
        ws.send(JSON.stringify({
          type: 'snapshot',
          data: this.buildSnapshot(),
        }));
        break;
      case 'ping':
        ws.send(JSON.stringify({ type: 'pong' }));
        break;
      default:
        ws.send(JSON.stringify({
          type: 'error',
          message: 'Unknown message type',
        }));
    }
  }

  private broadcastTournamentUpdate(eventType: string): void {
    if (this.sockets.size === 0) {
      return;
    }

    const payload = JSON.stringify({
      type: eventType,
      data: this.buildSnapshot(),
      timestamp: Date.now(),
    });

    for (const ws of Array.from(this.sockets)) {
      if (ws.readyState === WebSocket.READY_STATE_OPEN) {
        try {
          ws.send(payload);
        } catch (error) {
          logInternalError('TournamentRoom WS send error', error);
          this.sockets.delete(ws);
        }
      } else {
        this.sockets.delete(ws);
      }
    }
  }

  private buildSnapshot(): TournamentSnapshot {
    return {
      tournament: this.tournament,
      teams: Array.from(this.teams.values()),
      stages: Array.from(this.stages.values()),
      matches: Array.from(this.matches.values()),
      bracket: this.bracket,
    };
  }

  private async persistState(eventType: string): Promise<void> {
    const snapshot = this.buildSnapshot();
    await this.state.storage.put(this.storageKey, snapshot);

    if (this.env.TOURNAMENT_KV) {
      const tournamentId = this.state.id.toString();
      const payload = JSON.stringify({
        ...snapshot,
        eventType,
        updatedAt: Date.now(),
      });

      await this.env.TOURNAMENT_KV.put(
        `tournament:${tournamentId}`,
        payload,
        { expirationTtl: this.snapshotTtlSeconds },
      );

      await this.updateTournamentIndex(snapshot);
    }
  }

  private async updateTournamentIndex(snapshot: TournamentSnapshot): Promise<void> {
    if (!this.env.TOURNAMENT_KV || !snapshot.tournament) {
      return;
    }

    const tournamentId = this.state.id.toString();
    const summary = buildTournamentIndexRecord(tournamentId, snapshot.tournament);
    const indexKey = 'tournaments:index';
    const stored = await this.env.TOURNAMENT_KV.get(indexKey);
    let summaries: TournamentIndexRecord[] = [];

    if (stored) {
      try {
        summaries = JSON.parse(stored) as TournamentIndexRecord[];
      } catch (error) {
        logInternalError('Failed to parse tournaments index snapshot', error);
      }
    }

    const existingIndex = summaries.findIndex((entry) => entry.id === summary.id);
    if (existingIndex >= 0) {
      summaries[existingIndex] = summary;
    } else {
      summaries.unshift(summary);
    }

    await this.env.TOURNAMENT_KV.put(indexKey, JSON.stringify(summaries));
  }

  private async loadStateFromStorage(): Promise<void> {
    const snapshot = await this.state.storage.get<TournamentSnapshot>(this.storageKey);
    if (!snapshot) {
      return;
    }

    this.tournament = snapshot.tournament;
    this.bracket = snapshot.bracket ?? null;
    this.teams = new Map((snapshot.teams || []).map((team) => [team.id, team]));
    this.stages = new Map((snapshot.stages || []).map((stage) => [stage.id, stage]));
    this.matches = new Map((snapshot.matches || []).map((match) => [match.id, match]));
  }
}

function normalizeTournamentPath(path: string[]): string[] {
  if (path.length >= 3 && path[0] === 'api' && path[1] === 'tournaments') {
    return path.slice(3);
  }
  return path;
}

function buildTournamentIndexRecord(
  id: string,
  tournament: Tournament
): TournamentIndexRecord {
  return {
    ...tournament,
    id,
    updatedAt: Date.now(),
  };
}

function buildCorsHeaders(
  request: Request,
  env: Env
): { headers: Record<string, string> } | { response: Response } {
  const origin = request.headers.get('Origin') || '';
  const environment = (env.ENVIRONMENT || 'development').toLowerCase();
  const allowedOrigins = getAllowedOrigins(env);
  const allowWildcard = allowedOrigins.includes('*');

  if (
    environment === 'production' &&
    origin &&
    !allowWildcard &&
    !allowedOrigins.includes(origin)
  ) {
    return {
      response: new Response('Forbidden', {
        status: 403,
        headers: createCorsHeaders('null'),
      }),
    };
  }

  const corsOrigin = allowWildcard
    ? '*'
    : origin && allowedOrigins.includes(origin)
      ? origin
      : allowedOrigins[0] || '';

  return {
    headers: createCorsHeaders(corsOrigin),
  };
}

function createCorsHeaders(origin: string): Record<string, string> {
  return {
    'Access-Control-Allow-Origin': origin || 'null',
    'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
    'Access-Control-Allow-Headers': 'Content-Type, Authorization',
    'Access-Control-Max-Age': '86400',
  };
}

function getAllowedOrigins(env: Env): string[] {
  const environment = (env.ENVIRONMENT || 'development').toLowerCase();
  const configured = env.ALLOWED_ORIGINS
    ?.split(',')
    .map((value) => value.trim())
    .filter((value) => value.length > 0) || [];

  if (environment === 'production') {
    if (configured.length === 0) {
      throw new Error('ALLOWED_ORIGINS must be configured for production tournaments');
    }
    return configured;
  }

  return configured.length > 0 ? configured : ['*'];
}

function isOriginAllowed(request: Request, env: Env): boolean {
  const origin = request.headers.get('Origin');
  if (!origin) {
    return true;
  }

  const allowedOrigins = getAllowedOrigins(env);
  return allowedOrigins.includes('*') || allowedOrigins.includes(origin);
}

function logInternalError(message: string, error: unknown): void {
  console.error(
    JSON.stringify({
      level: 'error',
      message,
      error: error instanceof Error ? error.message : String(error),
      stack: error instanceof Error ? error.stack : undefined,
      timestamp: Date.now(),
    })
  );
}

