# Runbook: Kubernetes

## CrashLoopBackOff

**Symptoms:** Restart count climbing; Ready false.

```bash
kubectl describe pod <pod> -n <ns>          # Events
kubectl logs <pod> -n <ns> --previous
kubectl get pod <pod> -o yaml | less
```

**Common causes:** bad args, missing config/secret, failing migration, wrong image command, liveness too aggressive.

**Fix:** Correct config; loosen/fix probes; ensure dependencies ready (initContainer/wait).

## OOMKilled

**Symptoms:** `Last State: Terminated Reason: OOMKilled`; Exit 137.

```bash
kubectl describe pod <pod> | grep -A5 Last
kubectl top pod <pod>
```

**Fix:** Raise memory limit **or** fix leak; set requests realistically; check JVM heap vs limit.

## ImagePullBackOff / ErrImagePull

```bash
kubectl describe pod <pod>   # look at Failed to pull
```

| Cause | Fix |
|-------|-----|
| Wrong tag/digest | Fix image reference |
| Private registry auth | imagePullSecrets / IRSA |
| Rate limit Docker Hub | Mirror / auth / pull-through |
| Wrong arch | Multi-arch image |

## Pending Pods

```bash
kubectl describe pod <pod>   # FailedScheduling
kubectl get nodes -o wide
kubectl describe node <node>
```

Insufficient CPU/mem, taints, affinity, PVC unbound, ResourceQuota.

## Service not reachable

```bash
kubectl get svc,endpointslices -n <ns>
kubectl run tmp --rm -it --image=nicolaka/netshoot -- /bin/bash
# dig svc, curl pod IP and ClusterIP
```

Selector labels mismatch is classic.

## Rollback

```bash
kubectl rollout undo deployment/<name> -n <ns>
kubectl rollout status deployment/<name> -n <ns>
```
