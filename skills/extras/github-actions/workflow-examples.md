# GitHub Actions Workflow Examples

## CI with OIDC sketch

```yaml
name: ci
on:
  pull_request:
  push:
    branches: [main]
permissions:
  contents: read
  id-token: write
  packages: write
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with: { node-version: 22, cache: npm }
      - run: npm ci && npm test
  build:
    needs: test
    if: github.ref == 'refs/heads/main'
    runs-on: ubuntu-latest
    environment: production
    steps:
      - uses: actions/checkout@v4
      - name: Build and push
        run: echo "buildx + push + sign here"
```
