export interface Env {
  GAME_ROOM: DurableObjectNamespace;
  TOURNAMENT_ROOM: DurableObjectNamespace;
  GAME_STATE_KV?: KVNamespace; // Optional for now
  TOURNAMENT_KV?: KVNamespace; // Optional for now
  ALLOWED_ORIGINS?: string; // Comma-separated list of allowed origins
  ENVIRONMENT?: string; // 'development' | 'production'
  JWT_SECRET?: string; // Shared secret for JWT validation
}

export default {
  async fetch(request: Request, env: Env): Promise<Response> {
    const url = new URL(request.url);
    let corsHeaders = createCorsHeaders('*');

    try {
      const corsResult = buildCorsHeaders(request, env);
      if ('response' in corsResult) {
        return corsResult.response;
      }
      corsHeaders = corsResult.headers;

      if (request.method === 'OPTIONS') {
        return new Response(null, { headers: corsHeaders });
      }

      if (url.pathname.startsWith('/game/')) {
        const roomId = url.pathname.split('/')[2];
        if (!roomId) {
          return new Response('Room ID required', { status: 400, headers: corsHeaders });
        }

        const id = env.GAME_ROOM.idFromName(roomId);
        const stub = env.GAME_ROOM.get(id);
        return stub.fetch(request);
      }

      if (url.pathname === '/api/create-room') {
        return handleCreateRoom(request, env, corsHeaders);
      }

      if (url.pathname.startsWith('/api/room/')) {
        const roomId = url.pathname.split('/')[3];
        return handleGetRoomInfo(env, roomId, corsHeaders);
      }

      if (url.pathname.startsWith('/api/tournaments')) {
        return handleTournamentRequest(request, env, corsHeaders);
      }

      if (url.pathname === '/health') {
        return new Response(JSON.stringify({ status: 'ok', timestamp: Date.now() }), {
          headers: { ...corsHeaders, 'Content-Type': 'application/json' },
        });
      }

      return new Response('Not Found', { status: 404, headers: corsHeaders });
    } catch (error) {
      logInternalError('Unhandled worker error', error);
      return new Response('Internal Server Error', {
        status: 500,
        headers: corsHeaders,
      });
    }
  },
};

async function handleCreateRoom(
  request: Request,
  env: Env,
  corsHeaders: Record<string, string>
): Promise<Response> {
  const roomId = generateRoomId();
  const requestUrl = new URL(request.url);
  const protocol = requestUrl.protocol === 'https:' ? 'wss' : 'ws';

  return new Response(
    JSON.stringify({
      roomId,
      wsUrl: `${protocol}://${requestUrl.host}/game/${roomId}`,
    }),
    {
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
    }
  );
}

async function handleGetRoomInfo(
  env: Env,
  roomId: string,
  corsHeaders: Record<string, string>
): Promise<Response> {
  if (!roomId) {
    return new Response(JSON.stringify({ error: 'Room ID required' }), {
      status: 400,
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
    });
  }

  return new Response(
    JSON.stringify({
      roomId,
      status: 'active',
    }),
    {
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
    }
  );
}

function generateRoomId(): string {
  return Math.floor(1000 + Math.random() * 9000).toString();
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

function getAllowedOrigins(env: Env): string[] {
  const environment = (env.ENVIRONMENT || 'development').toLowerCase();
  const configured = env.ALLOWED_ORIGINS
    ?.split(',')
    .map((origin) => origin.trim())
    .filter((origin) => origin.length > 0) || [];

  if (environment === 'production') {
    if (configured.length === 0) {
      throw new Error('ALLOWED_ORIGINS must be configured in production');
    }
    return configured;
  }

  return configured.length > 0 ? configured : ['*'];
}

function createCorsHeaders(origin: string): Record<string, string> {
  return {
    'Access-Control-Allow-Origin': origin || 'null',
    'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
    'Access-Control-Allow-Headers': 'Content-Type, Authorization',
    'Access-Control-Max-Age': '86400',
  };
}

async function handleTournamentRequest(
  request: Request,
  env: Env,
  corsHeaders: Record<string, string>
): Promise<Response> {
  const url = new URL(request.url);
  const path = url.pathname.split('/').filter(Boolean);
  const isTournamentRoute = path.length >= 2 && path[0] === 'api' && path[1] === 'tournaments';

  if (!isTournamentRoute) {
    return new Response(JSON.stringify({ error: 'Invalid tournament endpoint' }), {
      status: 404,
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
    });
  }

  if (path.length === 2) {
    if (request.method === 'GET') {
      return handleTournamentList(env, corsHeaders);
    }

    if (request.method === 'POST') {
      return handleTournamentCreation(request, env, corsHeaders);
    }

    return new Response(JSON.stringify({ error: 'Method not allowed' }), {
      status: 405,
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
    });
  }

  const tournamentId = path[2];
  if (!tournamentId) {
    return new Response(JSON.stringify({ error: 'Tournament ID required' }), {
      status: 400,
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
    });
  }

  const id = env.TOURNAMENT_ROOM.idFromName(tournamentId);
  const stub = env.TOURNAMENT_ROOM.get(id);
  const forwardRequest = buildTournamentForwardRequest(request, path);
  const response = await stub.fetch(forwardRequest);
  const bodyText = await response.text();
  const contentType = response.headers.get('Content-Type');

  return new Response(bodyText, {
    status: response.status,
    headers: {
      ...corsHeaders,
      ...(contentType ? { 'Content-Type': contentType } : {}),
    },
  });
}

async function handleTournamentCreation(
  request: Request,
  env: Env,
  corsHeaders: Record<string, string>
): Promise<Response> {
  const tournamentId = `tournament_${Date.now()}_${Math.random().toString(36).substring(2, 9)}`;
  const id = env.TOURNAMENT_ROOM.idFromName(tournamentId);
  const stub = env.TOURNAMENT_ROOM.get(id);

  const forwardUrl = new URL(request.url);
  forwardUrl.pathname = '/tournament';
  const forwardRequest = new Request(forwardUrl.toString(), request);

  const response = await stub.fetch(forwardRequest);
  const responseText = await response.text();
  const headers = { ...corsHeaders, 'Content-Type': 'application/json' };

  if (!response.ok) {
    return new Response(responseText, { status: response.status, headers });
  }

  const data = responseText ? JSON.parse(responseText) as Record<string, unknown> : {};
  if (!data.id) {
    data.id = tournamentId;
  }

  return new Response(JSON.stringify(data), {
    status: 201,
    headers,
  });
}

async function handleTournamentList(
  env: Env,
  corsHeaders: Record<string, string>
): Promise<Response> {
  if (!env.TOURNAMENT_KV) {
    return new Response(JSON.stringify({ tournaments: [] }), {
      status: 200,
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
    });
  }

  const stored = await env.TOURNAMENT_KV.get('tournaments:index');
  let tournaments: unknown[] = [];
  if (stored) {
    try {
      tournaments = JSON.parse(stored) as unknown[];
    } catch (error) {
      logInternalError('Failed to parse tournaments index', error);
    }
  }

  return new Response(
    JSON.stringify({ tournaments }),
    {
      status: 200,
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
    }
  );
}

function buildTournamentForwardRequest(
  request: Request,
  path: string[]
): Request {
  const forwardUrl = new URL(request.url);
  const segments = path.slice(3);
  const normalizedSegments = segments.length === 0 ? ['tournament'] : segments;
  forwardUrl.pathname = `/${normalizedSegments.join('/')}`;
  return new Request(forwardUrl.toString(), request);
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

export { GameRoom } from './GameRoom';
export { TournamentRoom } from './TournamentRoom';
