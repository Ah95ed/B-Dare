/**
 * Load Testing Script for Mystery Link Backend
 * 
 * This script simulates multiple concurrent players connecting to the game
 * and sending messages to test the backend's performance and reliability.
 * 
 * Usage:
 *   npx tsx test/load_test.ts --players 100 --messages 10 --baseUrl https://your-worker.workers.dev
 */

import WebSocket from 'ws';

interface TestConfig {
  players: number;
  messagesPerPlayer: number;
  baseUrl: string;
  roomId: string;
  delayBetweenMessages: number; // milliseconds
}

interface TestResult {
  totalConnections: number;
  successfulConnections: number;
  failedConnections: number;
  totalMessages: number;
  successfulMessages: number;
  failedMessages: number;
  averageResponseTime: number;
  errors: string[];
}

class LoadTester {
  private config: TestConfig;
  private results: TestResult = {
    totalConnections: 0,
    successfulConnections: 0,
    failedConnections: 0,
    totalMessages: 0,
    successfulMessages: 0,
    failedMessages: 0,
    averageResponseTime: 0,
    errors: [],
  };

  private responseTimes: number[] = [];

  constructor(config: TestConfig) {
    this.config = config;
  }

  async run(): Promise<TestResult> {
    console.log(`Starting load test with ${this.config.players} players...`);
    console.log(`Base URL: ${this.config.baseUrl}`);
    console.log(`Room ID: ${this.config.roomId}`);
    console.log('');

    const startTime = Date.now();
    const connections: Promise<void>[] = [];

    // إنشاء اتصالات متزامنة
    for (let i = 0; i < this.config.players; i++) {
      connections.push(this.connectPlayer(i));
    }

    await Promise.all(connections);

    const endTime = Date.now();
    const totalTime = endTime - startTime;

    // حساب المتوسطات
    if (this.responseTimes.length > 0) {
      this.results.averageResponseTime =
        this.responseTimes.reduce((a, b) => a + b, 0) / this.responseTimes.length;
    }

    // طباعة النتائج
    console.log('\n=== Load Test Results ===');
    console.log(`Total Time: ${totalTime}ms (${(totalTime / 1000).toFixed(2)}s)`);
    console.log(`Connections: ${this.results.successfulConnections}/${this.results.totalConnections} successful`);
    console.log(`Messages: ${this.results.successfulMessages}/${this.results.totalMessages} successful`);
    console.log(`Average Response Time: ${this.results.averageResponseTime.toFixed(2)}ms`);
    console.log(`Success Rate: ${((this.results.successfulConnections / this.results.totalConnections) * 100).toFixed(2)}%`);
    
    if (this.results.errors.length > 0) {
      console.log(`\nErrors (${this.results.errors.length}):`);
      this.results.errors.slice(0, 10).forEach((error, i) => {
        console.log(`  ${i + 1}. ${error}`);
      });
      if (this.results.errors.length > 10) {
        console.log(`  ... and ${this.results.errors.length - 10} more errors`);
      }
    }

    return this.results;
  }

  private async connectPlayer(playerIndex: number): Promise<void> {
    const playerId = `player_${playerIndex}`;
    const playerName = `Player ${playerIndex}`;
    const url = `${this.config.baseUrl}/game/${this.config.roomId}?playerId=${playerId}&playerName=${encodeURIComponent(playerName)}`;

    return new Promise((resolve) => {
      this.results.totalConnections++;

      try {
        const ws = new WebSocket(url.replace('https://', 'wss://').replace('http://', 'ws://'));

        ws.on('open', () => {
          this.results.successfulConnections++;
          console.log(`Player ${playerIndex} connected`);

          // إرسال رسائل
          this.sendMessages(ws, playerIndex, playerId).then(() => {
            ws.close();
            resolve();
          });
        });

        ws.on('error', (error) => {
          this.results.failedConnections++;
          this.results.errors.push(`Player ${playerIndex} connection error: ${error.message}`);
          resolve();
        });

        ws.on('message', (data) => {
          const message = JSON.parse(data.toString());
          // يمكن إضافة منطق لقياس response time هنا
        });

        ws.on('close', () => {
          resolve();
        });
      } catch (error: any) {
        this.results.failedConnections++;
        this.results.errors.push(`Player ${playerIndex} error: ${error.message}`);
        resolve();
      }
    });
  }

  private async sendMessages(ws: WebSocket, playerIndex: number, playerId: string): Promise<void> {
    for (let i = 0; i < this.config.messagesPerPlayer; i++) {
      await new Promise((resolve) => setTimeout(resolve, this.config.delayBetweenMessages));

      const message = {
        type: 'requestGameState',
      };

      const startTime = Date.now();
      this.results.totalMessages++;

      try {
        ws.send(JSON.stringify(message));
        this.results.successfulMessages++;
        
        const responseTime = Date.now() - startTime;
        this.responseTimes.push(responseTime);
      } catch (error: any) {
        this.results.failedMessages++;
        this.results.errors.push(`Player ${playerIndex} message ${i} error: ${error.message}`);
      }
    }
  }
}

// Parse command line arguments
const args = process.argv.slice(2);
const config: TestConfig = {
  players: parseInt(args.find(arg => arg.startsWith('--players'))?.split('=')[1] || '10'),
  messagesPerPlayer: parseInt(args.find(arg => arg.startsWith('--messages'))?.split('=')[1] || '5'),
  baseUrl: args.find(arg => arg.startsWith('--baseUrl'))?.split('=')[1] || 'http://localhost:8787',
  roomId: args.find(arg => arg.startsWith('--roomId'))?.split('=')[1] || '1234',
  delayBetweenMessages: parseInt(args.find(arg => arg.startsWith('--delay'))?.split('=')[1] || '100'),
};

// Run the test
const tester = new LoadTester(config);
tester.run().then((results) => {
  if (results.failedConnections > 0 || results.failedMessages > 0) {
    process.exit(1);
  }
  process.exit(0);
}).catch((error) => {
  console.error('Test failed:', error);
  process.exit(1);
});

