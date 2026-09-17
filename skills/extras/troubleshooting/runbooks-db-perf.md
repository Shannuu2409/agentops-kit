# Runbook: Database Connectivity and Performance Bottlenecks

## Cannot connect

```bash
# From app network namespace
nc -vz db-host 5432
openssl s_client -connect db-host:5432 </dev/null   # if TLS
# Postgres
psql "host=... dbname=... user=... sslmode=require"
```

| Cause | Fix |
|-------|-----|
| SG/NACL | Open app SG → DB SG |
| Wrong host (public vs private) | Use private endpoint |
| Password rotated | Sync secret store |
| TLS required | Enable sslmode |
| Max connections | Pooler; raise/limit apps |

## Saturation / slow queries

```sql
-- Postgres
SELECT pid, now()-query_start, state, query FROM pg_stat_activity ORDER BY 2 DESC LIMIT 20;
SELECT * FROM pg_stat_statements ORDER BY total_exec_time DESC LIMIT 20;
```

**Symptoms:** rising p99, connection wait, disk IOwait, replica lag.

**Fix:** kill runaway (carefully); add index; increase pool wisely; scale IOPS; read replica.

## Redis

```bash
redis-cli INFO; redis-cli INFO memory; redis-cli SLOWLOG GET 10
```

Evictions? maxmemory policy? Hot keys?

## Performance bottleneck (generic)

1. Golden signals → which tier?
2. Trace slow span
3. Profile if CPU; EXPLAIN if DB; `ss` if conn exhaustion
4. Load test fix in staging
