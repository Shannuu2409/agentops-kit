# Runbook: Docker Failures

## Container exits immediately

**Symptoms:** `Exited (1)` or `(137)`.

**Commands:**
```bash
docker ps -a
docker logs <id>
docker inspect <id> --format '{{.State.ExitCode}} {{.State.OOMKilled}} {{.State.Error}}'
```

| Exit | Meaning | Fix |
|------|---------|-----|
| 1 | App error | Fix command/config from logs |
| 127 | Binary missing | Fix PATH/ENTRYPOINT |
| 137 | SIGKILL / OOM | Raise memory; fix leak |
| 139 | SIGSEGV | Native crash / arch mismatch |

**Prevention:** Healthchecks; non-root tested locally; resource limits in Compose.

## Cannot connect to Docker daemon

```bash
systemctl status docker
ls -l /var/run/docker.sock
# Rootless: export DOCKER_HOST=unix://$XDG_RUNTIME_DIR/docker.sock
```

## Image build fails / cache weirdness

```bash
docker build --progress=plain --no-cache -t app:debug .
cat .dockerignore
```

## Networking between Compose services

- Use **service name** as hostname on user-defined network
- `docker compose exec api ping db`
- Check published ports vs internal ports (map host:container carefully)
