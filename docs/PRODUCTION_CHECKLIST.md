# Production Deployment Checklist

Use this checklist before deploying to production.

## Pre-Deployment

### Code Quality
- [ ] All linter errors fixed
- [ ] All tests passing
- [ ] Code review completed
- [ ] Security audit passed
- [ ] Performance testing completed

### Configuration
- [ ] Environment variables configured
- [ ] KV namespaces created
- [x] CORS origins restricted (not using '*')
- [ ] Rate limiting configured
- [ ] Error handling tested

### Security
- [x] Authentication implemented (JWT recommended)
- [ ] Input validation on all endpoints
- [ ] Rate limiting enabled
- [x] CORS properly configured
- [x] Error messages don't expose internal details
- [ ] Secrets stored securely (not in code)

### Monitoring
- [ ] Cloudflare Analytics enabled
- [ ] Error tracking configured
- [ ] Logging set up
- [ ] Alerts configured
- [ ] Health check endpoint working

### Testing
- [ ] Unit tests passing
- [ ] Integration tests passing
- [ ] Load testing completed (1000+ users)
- [ ] Security testing completed
- [ ] Manual testing completed

## Deployment Steps

1. [ ] Backup current production (if exists)
2. [ ] Deploy to staging first
3. [ ] Test staging deployment
4. [ ] Deploy to production
5. [ ] Verify production deployment
6. [ ] Monitor for errors
7. [ ] Update documentation

## Post-Deployment

- [ ] Verify all endpoints working
- [ ] Check error rates
- [ ] Monitor performance metrics
- [ ] Test WebSocket connections
- [ ] Verify KV storage working
- [ ] Check rate limiting
- [ ] Review logs for errors

## Rollback Plan

If issues occur:
1. [ ] Identify the issue
2. [ ] Check error logs
3. [ ] Rollback if necessary: `wrangler rollback`
4. [ ] Notify team
5. [ ] Document the issue

## Emergency Contacts

- Development Team: [contact info]
- Cloudflare Support: https://support.cloudflare.com
- On-call Engineer: [contact info]

## Notes

- Always deploy during low-traffic hours if possible
- Have rollback plan ready
- Monitor closely for first 24 hours
- Document any issues or changes

