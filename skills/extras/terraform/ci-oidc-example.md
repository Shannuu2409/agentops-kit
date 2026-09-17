# Terraform CI with OIDC (sketch)

## Goals

- PR: `terraform plan` only
- Main: `apply` with environment approval
- No long-lived cloud keys

## Job outline

```yaml
permissions:
  contents: read
  id-token: write
  pull-requests: write
steps:
  - uses: actions/checkout@v4
  - uses: hashicorp/setup-terraform@v3
  - uses: aws-actions/configure-aws-credentials@v4
    with:
      role-to-assume: arn:aws:iam::123456789012:role/gha-terraform
      aws-region: us-east-1
  - run: terraform init
  - run: terraform plan -out=tfplan
  - run: terraform apply -auto-approve tfplan
    if: github.ref == 'refs/heads/main' && github.event_name == 'push'
```

Lock state with S3 + DynamoDB. Restrict the IAM role to the specific state bucket and target accounts.

---

**Author & maintainer:** Shanmukha Kumar Karra  
*Created and maintained as part of [AgentOps Kit](https://github.com/Shannuu2409/agentops-kit).*
