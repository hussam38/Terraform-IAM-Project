# IAM Project 🔐

[![Terraform](https://img.shields.io/badge/Terraform-configuration-blue?logo=terraform)](https://www.terraform.io) [![Status](https://img.shields.io/badge/status-example-yellow)](https://github.com) [![License](https://img.shields.io/badge/license-hussam38-red)](https://choosealicense.com)

This Project is an AWS IAM example that maps users to specific IAM roles using the data in `users-roles.yaml`.

Summary: the config reads a YAML file of users and assigned roles, creates IAM users and login profiles, creates IAM roles with trust policies that allow the assigned users to assume those roles, and attaches AWS managed policies to roles.

## Quick start (clone the repo)

1. Clone the repository and enter the IAM project directory:

```bash
git clone <REPO_URL> iam-project
cd iam-project
```

2. Initialize and preview changes:

```bash
terraform init
terraform plan -out=plan.tfplan
terraform apply "plan.tfplan"
```

3. Tear down when finished:

```bash
terraform destroy
```

> Tip: Replace `<REPO_URL>` and `<repo-name>` with the repository URL and directory name.

## Project purpose

This example demonstrates a pattern: using a declarative YAML file (`users-roles.yaml`) as the single source of truth to map users to roles. The mapping controls which principals appear in role trust policies and which managed policies are attached to each role.

## Contents & hierarchy

| Component | Purpose | Notes |
|---|---|---|
| `users-roles.yaml` | Source of truth for users and their roles | Edit this file to change assignments |
| `users.tf` | Creates IAM users & login profiles | Reads `users-roles.yaml` via `yamldecode(file(...))` |
| `roles.tf` | Creates roles, trust policies, and attachments | Reads `roles_policies` locals and builds policies/attachments |
| `provider.tf` | AWS provider configuration | Set credentials and region here |
| `outputs.tf` | Exposes values after apply | e.g., generated passwords or ARNs |

## Example

`users-roles.yaml` sample:

```yaml
users:
	- username: john
		roles: [readonly, developer]
	- username: jane
		roles: [admin, auditor]
```

## Security & notes

- This is an example; review and adapt IAM design before using in production.
- State files in this folder are local; consider a remote backend for team usage.
