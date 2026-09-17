# Runbook: GitHub Actions Failures

## Job fails on dependency install

- Confirm lockfile committed
- Clear cache key if corrupt
- Check registry auth / npm token permissions

## OIDC / cloud auth fails

```text
Could not assume role / Invalid identity token
```

**Check:** `permissions: id-token: write`; IAM trust `sub`/`aud` matches repo/branch; environment name if constrained.

## Secret not found

- Secret exists at **same scope** (env vs repo)
- Fork PRs don't get secrets by default
- Names case-sensitive

## Flaky tests

- Re-run failed jobs; quarantine flakes; add timeouts
- Check shared resource races

## Runner disk full / timeout

- Prune docker; reduce artifacts; increase timeout minutes
- Self-hosted: clean workspaces between jobs

## Debug mode

Repo secret `ACTIONS_STEP_DEBUG=true` (and runner debug as needed). Remove after.
