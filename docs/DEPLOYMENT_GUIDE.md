# Deployment Guide - Mystery Link Backend

## Prerequisites

1. **Cloudflare Account**
   - Sign up at https://cloudflare.com
   - Verify your account

2. **Wrangler CLI**
   ```bash
   npm install -g wrangler
   ```

3. **Node.js & npm**
   - Node.js 18+ required
   - npm 9+ recommended

## Step 1: Authentication

### Option A: Browser Login (Recommended for first-time setup)
```bash
cd backend
wrangler login
```
This will open your browser for authentication.

### Option B: API Token (Recommended for CI/CD)
1. Go to Cloudflare Dashboard → My Profile → API Tokens
2. Create a token with:
   - Account: Cloudflare Workers:Edit
   - Zone: (if using custom domain)
3. Set environment variable:
   ```bash
   export CLOUDFLARE_API_TOKEN=your_token_here
   ```

## Step 2: Configure KV Namespace

### Create KV Namespace
```bash
wrangler kv:namespace create "GAME_STATE_KV"
```

This will output something like:
```
🌀  Creating namespace with title "mystery-link-backend-GAME_STATE_KV"
✨  Success!
Add the following to your configuration file in your kv_namespaces array:
{ binding = "GAME_STATE_KV", id = "abc123..." }
```

### Update wrangler.toml
Add the namespace ID to `backend/wrangler.toml`:
```toml
[[kv_namespaces]]
binding = "GAME_STATE_KV"
id = "abc123..."  # Replace with your actual ID
```

### Create Preview Namespace (for local development)
```bash
wrangler kv:namespace create "GAME_STATE_KV" --preview
```

Add to `wrangler.toml`:
```toml
[[kv_namespaces]]
binding = "GAME_STATE_KV"
preview_id = "preview_abc123..."  # Replace with your preview ID
```

## Step 3: Build the Project

```bash
cd backend
npm install
npm run build
```

## Step 4: Deploy to Cloudflare

### Development Deployment
```bash
wrangler deploy
```

### Production Deployment
```bash
wrangler deploy --env production
```

### Custom Domain (Optional)
1. Add custom domain in Cloudflare Dashboard
2. Update `wrangler.toml`:
   ```toml
   [env.production]
   routes = [
     { pattern = "api.yourdomain.com", custom_domain = true }
   ]
   ```

## Step 5: Verify Deployment

### Health Check
```bash
curl https://your-worker.workers.dev/health
```

Expected response:
```json
{"status":"ok","timestamp":1234567890}
```

### Test WebSocket Connection
```bash
# Using wscat (install: npm install -g wscat)
wscat -c wss://your-worker.workers.dev/game/1234?playerId=test&playerName=Test
```

## Step 6: Update Flutter App

Update `lib/core/constants/app_constants.dart`:
```dart
static const String cloudflareWorkerUrl = 'https://your-worker.workers.dev';
```

Or use environment variables:
```dart
static const String cloudflareWorkerUrl = 
    String.fromEnvironment('CLOUDFLARE_WORKER_URL', 
    defaultValue: 'https://your-worker.workers.dev');
```

## Step 7: Monitoring Setup

### Cloudflare Analytics
1. Go to Workers Dashboard
2. View analytics for your worker
3. Monitor:
   - Request count
   - Error rate
   - Response time
   - Durable Objects usage

### Custom Monitoring (Optional)
1. Set up external monitoring service (e.g., Datadog, New Relic)
2. Add health check endpoint monitoring
3. Set up alerts for:
   - High error rate
   - Slow response times
   - Durable Object failures

## Step 8: Environment Variables

### Production Environment Variables
```bash
wrangler secret put ENVIRONMENT
# Enter: production

wrangler secret put ALLOWED_ORIGINS
# Enter: https://yourdomain.com,https://www.yourdomain.com
```

### Update wrangler.toml for Secrets
```toml
[env.production.vars]
ENVIRONMENT = "production"
```

## Troubleshooting

### Common Issues

1. **"Namespace not found"**
   - Ensure KV namespace is created
   - Check namespace ID in `wrangler.toml`
   - Run `wrangler kv:namespace list` to verify

2. **"Authentication failed"**
   - Re-run `wrangler login`
   - Check API token permissions
   - Verify account access

3. **"WebSocket connection failed"**
   - Check CORS settings
   - Verify worker URL
   - Check browser console for errors

4. **"Durable Object not found"**
   - Ensure migrations are configured
   - Check class name matches
   - Verify binding name

### Debug Mode
```bash
# Local development with debugging
wrangler dev --local

# Remote debugging
wrangler dev
```

### View Logs
```bash
# Real-time logs
wrangler tail

# Filtered logs
wrangler tail --format pretty
```

## CI/CD Integration

### GitHub Actions Example
```yaml
name: Deploy to Cloudflare

on:
  push:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-node@v3
        with:
          node-version: '18'
      - name: Install dependencies
        run: |
          cd backend
          npm install
      - name: Deploy
        run: |
          cd backend
          wrangler deploy
        env:
          CLOUDFLARE_API_TOKEN: ${{ secrets.CLOUDFLARE_API_TOKEN }}
```

## Rollback Procedure

If deployment fails:

1. **Check previous version:**
   ```bash
   wrangler deployments list
   ```

2. **Rollback to previous version:**
   ```bash
   wrangler rollback
   ```

3. **Or deploy specific version:**
   ```bash
   wrangler deploy --version <version-id>
   ```

## Production Checklist

Before going to production:

- [ ] KV namespaces created and configured
- [ ] Environment variables set
- [ ] CORS restricted to specific origins
- [ ] Rate limiting tested
- [ ] Monitoring set up
- [ ] Error tracking configured
- [ ] Load testing completed
- [ ] Security audit passed
- [ ] Backup procedures in place
- [ ] Documentation updated
- [ ] Team trained on deployment process

## Support

For issues or questions:
1. Check Cloudflare Workers documentation
2. Review error logs: `wrangler tail`
3. Contact development team

