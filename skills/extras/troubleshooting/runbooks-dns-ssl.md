# Runbook: DNS and SSL

## DNS does not resolve

```bash
dig +trace example.com
dig @8.8.8.8 api.example.com
dig api.example.com NS
```

| Symptom | Cause | Fix |
|---------|-------|-----|
| NXDOMAIN | Record missing/typo | Add record |
| Old IP | TTL cache | Wait TTL; lower next time |
| ServFail | Auth NS broken | Fix delegation |
| Works publicly not in VPC | Private zone / resolver | Check DHCP option set / CoreDNS |

## Kubernetes DNS

```bash
kubectl -n kube-system get pods -l k8s-app=kube-dns
kubectl run tmp --rm -it --image=busybox -- nslookup kubernetes.default
```

## Certificate errors

```bash
openssl s_client -connect host:443 -servername host </dev/null 2>/dev/null | openssl x509 -noout -dates -ext subjectAltName
```

| Error | Fix |
|-------|-----|
| expired | Renew / fix ACME |
| hostname mismatch | Fix SAN |
| unable to get local issuer | Serve intermediate chain |
| alert handshake failure | TLS version/cipher mismatch |

cert-manager: `kubectl describe certificate`; check Order/Challenge events.
