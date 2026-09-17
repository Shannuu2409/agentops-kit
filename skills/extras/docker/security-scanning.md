# Docker Security Scanning

## CI pattern

```bash
docker build -t $IMAGE:$TAG .
trivy image --exit-code 1 --severity CRITICAL,HIGH $IMAGE:$TAG
syft $IMAGE:$TAG -o spdx-json > sbom.spdx.json
cosign sign --yes $IMAGE@$DIGEST
```

## Runtime hardening flags

```bash
docker run --read-only --tmpfs /tmp \
  --cap-drop ALL --security-opt no-new-privileges \
  --user 10001:10001 -p 8080:8080 myapp:1.2.3
```

---

**Author & maintainer:** Shanmukha Kumar Karra  
*Created and maintained as part of [AgentOps Kit](https://github.com/Shannuu2409/agentops-kit).*
