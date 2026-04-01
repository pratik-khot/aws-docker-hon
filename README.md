# AWS Docker Terraform Setup

This repository contains Terraform configurations to set up AWS infrastructure for Docker-based deployments.

## Prerequisites

1. **AWS OIDC Provider Setup**:
   - Create an OpenID Connect (OIDC) identity provider in AWS IAM.
   - Provider URL: `https://token.actions.githubusercontent.com`
   - Provider Type: OpenID Connect
   - Audience: `sts.amazonaws.com`

2. **IAM Role for GitHub Actions**:
   - Create an IAM role that GitHub Actions can assume using OIDC.
   - Attach necessary permissions for your Terraform resources (e.g., EC2, VPC, etc.).
   - Trust policy should allow the OIDC provider.

## GitHub Secrets

Add the following secrets in your repository settings (`Settings > Secrets and variables > Actions`):

- `AWS_ROLE_TO_ASSUME`: The ARN of the IAM role for GitHub Actions (e.g., `arn:aws:iam::123456789012:role/GitHubActionsRole`)
- `AWS_REGION`: The AWS region for deployments (e.g., `us-east-1`)

## Usage

### Local Development

1. Install Terraform (v1.x recommended).
2. Initialize: `terraform init`
3. Plan: `terraform plan`
4. Apply: `terraform apply`
5. Destroy: `terraform destroy`

### GitHub Actions Workflow

The `.github/workflows/deploy.yml` automates Terraform operations:

- **Pull Request**: Runs `terraform plan` only (no apply) for review.
- **Push to main**: Runs `terraform plan` and `apply` automatically.
- **Manual Dispatch**:
  - `apply`: Runs `terraform plan` and `apply`.
  - `destroy`: Runs `terraform plan -destroy` and `apply` (requires environment approval if configured).

For destroy operations, an `environment: destroy` is used, which can be protected with required reviewers in GitHub settings.

## Project Structure

- `backend.tf`: Terraform backend configuration.
- `data.tf`: Data sources.
- `main.tf`: Main infrastructure resources.
- `output.tf`: Outputs.
- `provider.tf`: AWS provider configuration.
- `variable.tf`: Variables.
- `userdata.sh`: User data script for instances.
- `.github/workflows/deploy.yml`: GitHub Actions workflow.
