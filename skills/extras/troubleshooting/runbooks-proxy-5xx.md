# Runbook: Nginx, Kong, and HTTP 502/503/504

## Status code meanings (edge)

| Code | Typical meaning |
|------|-----------------|
| **502** Bad Gateway | Upstream refused/reset/invalid response |
| **503** Unavailable | No healthy upstream / deliberate shed |
| **504** Gateway Timeout | Upstream too slow |

## Nginx

```bash
tail -f /var/log/nginx/error.log
nginx -T | grep -E 'proxy_pass|upstream|timeout'
curl -v http://upstream:8080/healthz
```

**502 causes:** upstream down, wrong port, SSL to upstream mismatch, header too large.  
**504 causes:** `proxy_read_timeout` low; app stuck; DB lock.

**Trailing slash `proxy_pass`:** can strip/rewrite paths unexpectedly — verify final upstream URL.

## Kong

```bash
curl -i https://gw/path
kubectl logs -n kong deploy/kong --tail=200
# Check targets health via Admin (private network only)
```

Verify route match (host/path), plugins (auth 401 vs 5xx), upstream targets healthy, timeouts.

## ALB/K8s Ingress

- Target health unhealthy → app readiness
- Idle timeout vs long requests
- MTU/VPN issues rare but cause hangs

## Mitigation

- Rollback deploy
- Scale healthy version
- Bypass gateway only with extreme care (security)
