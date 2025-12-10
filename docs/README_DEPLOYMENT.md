# Mystery Link - Deployment Documentation

## Quick Start

1. **Install Dependencies**
   ```bash
   cd backend
   npm install
   ```

2. **Authenticate with Cloudflare**
   ```bash
   wrangler login
   ```

3. **Create KV Namespace**
   ```bash
   wrangler kv:namespace create "GAME_STATE_KV"
   ```
   Update `wrangler.toml` with the returned ID.

4. **Deploy**
   ```bash
   npm run deploy
   ```

5. **Update Flutter App**
   Update `lib/core/constants/app_constants.dart` with your worker URL.

## Documentation Files

- **[DEPLOYMENT_GUIDE.md](DEPLOYMENT_GUIDE.md)** - Detailed deployment instructions
- **[SECURITY_AUDIT.md](SECURITY_AUDIT.md)** - Security audit checklist and recommendations
- **[PRODUCTION_CHECKLIST.md](PRODUCTION_CHECKLIST.md)** - Pre-production checklist

## Testing

### Load Testing
```bash
cd backend
npm run test:load
```

### Manual Testing
1. Create a room via API
2. Connect multiple WebSocket clients
3. Test game flow
4. Verify state persistence

## Monitoring

- **Cloudflare Dashboard**: View worker analytics
- **Logs**: `wrangler tail` for real-time logs
- **Health Check**: `curl https://your-worker.workers.dev/health`

## Support

For issues or questions, refer to:
1. Cloudflare Workers documentation
2. Error logs: `wrangler tail`
3. Development team

