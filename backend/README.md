# Mystery Link Backend - Cloudflare Workers

Backend للعب الجماعي المزامن للعبة Mystery Link باستخدام Cloudflare Workers و Durable Objects.

## الميزات

- ✅ WebSocket support للاتصال الفوري
- ✅ Durable Objects لإدارة غرف اللعب
- ✅ مزامنة حالة اللعبة بين اللاعبين
- ✅ إدارة اللاعبين (انضمام/مغادرة)
- ✅ Turn-based gameplay support
- ✅ Timer synchronization

## المتطلبات

- Node.js v18 أو أحدث
- npm أو yarn
- حساب Cloudflare (مجاني)

## التثبيت

```bash
# تثبيت dependencies
npm install

# أو باستخدام yarn
yarn install
```

## التطوير المحلي

```bash
# تشغيل خادم تطوير محلي
npm run dev

# أو
wrangler dev
```

الخادم سيعمل على `http://localhost:8787`

## النشر

```bash
# تسجيل الدخول في Cloudflare
wrangler login

# نشر المشروع
npm run deploy

# أو
wrangler deploy
```

## API Endpoints

### REST API

#### `GET /health`
Health check endpoint

**Response:**
```json
{
  "status": "ok",
  "timestamp": 1234567890
}
```

#### `POST /api/create-room`
إنشاء غرفة لعبة جديدة

**Response:**
```json
{
  "roomId": "1234",
  "wsUrl": "wss://mystery-link-backend.workers.dev/game/1234"
}
```

#### `GET /api/room/:roomId`
الحصول على معلومات الغرفة

**Response:**
```json
{
  "roomId": "1234",
  "status": "active"
}
```

### WebSocket API

#### الاتصال
```
wss://mystery-link-backend.workers.dev/game/:roomId?playerId=xxx&playerName=Player%201
```

#### الرسائل المرسلة من Client

**بدء اللعبة:**
```json
{
  "type": "startGame",
  "config": {
    "representationType": "text",
    "linksCount": 5,
    "category": "General Knowledge",
    "puzzleId": "puzzle_1"
  }
}
```

**اختيار إجابة:**
```json
{
  "type": "selectOption",
  "selectedNode": {
    "id": "node_1",
    "label": "Option 1",
    "representationType": "text"
  },
  "stepOrder": 1
}
```

**طلب حالة اللعبة:**
```json
{
  "type": "requestGameState"
}
```

#### الرسائل الواردة من Server

**اتصال ناجح:**
```json
{
  "type": "connected",
  "playerId": "player_1",
  "isHost": true,
  "gameState": null,
  "players": [...]
}
```

**لاعب انضم:**
```json
{
  "type": "playerJoined",
  "player": {...},
  "players": [...]
}
```

**اللعبة بدأت:**
```json
{
  "type": "gameStarted",
  "gameState": {...}
}
```

**خطوة اكتملت:**
```json
{
  "type": "stepCompleted",
  "gameState": {...},
  "players": [...],
  "selectedNode": {...},
  "isCorrect": true
}
```

**إجابة خاطئة:**
```json
{
  "type": "wrongAnswer",
  "gameState": {...},
  "players": [...],
  "playerId": "player_1",
  "selectedNode": {...}
}
```

**اللعبة اكتملت:**
```json
{
  "type": "gameCompleted",
  "gameState": {...},
  "players": [...]
}
```

**تحديث المؤقت:**
```json
{
  "type": "timerTick",
  "remainingSeconds": 45
}
```

## البنية

```
backend/
├── src/
│   ├── index.ts          # Entry point للـ Worker
│   └── GameRoom.ts       # Durable Object لإدارة غرف اللعب
├── package.json
├── wrangler.toml         # إعدادات Cloudflare
├── tsconfig.json
└── README.md
```

## التكاليف

### Free Tier:
- ✅ 100,000 request/يوم
- ✅ 10ms CPU time/request
- ✅ 1M Durable Object requests/شهر
- ✅ **كافي لـ 100+ لاعب نشط يومياً**

### Paid (إذا تجاوزت الحدود):
- 💰 $5/شهر للـ Workers (10M requests)
- 💰 $0.15/M Durable Object requests

## المراقبة

```bash
# متابعة الـ logs
npm run tail

# أو
wrangler tail
```

## التحسينات المستقبلية

- [ ] تخزين الألغاز في Cloudflare KV
- [ ] Authentication باستخدام JWT
- [ ] Rate limiting
- [ ] Analytics و monitoring
- [ ] دعم Reconnection
- [ ] Chat بين اللاعبين

## إعداد الإنتاج (Production Setup)

1. حرر ملف `wrangler.toml` وأضف قيم `ENVIRONMENT` و `ALLOWED_ORIGINS` داخل `[env.production.vars]`.
2. خزن مفتاح JWT بشكل آمن عبر:
   ```bash
   wrangler secret put JWT_SECRET --env production
   ```
3. أنشئ KV namespaces لـ `GAME_STATE_KV` و `TOURNAMENT_KV` وأضف المعرّفات إلى `wrangler.toml`.
4. انشر بيئة الإنتاج باستخدام:
   ```bash
   wrangler deploy --env production
   ```

## الدعم

للمزيد من المعلومات:
- [Cloudflare Workers Docs](https://developers.cloudflare.com/workers/)
- [Durable Objects Guide](https://developers.cloudflare.com/durable-objects/)
- [WebSocket API](https://developers.cloudflare.com/workers/learning/using-websockets/)

---

**تم التطوير**: 2 ديسمبر 2025  
**الحالة**: جاهز للاستخدام ✅

