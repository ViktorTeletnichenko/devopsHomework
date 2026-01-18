# GitLab Terraform homework

## What is created
- GitLab group
- 3 projects: app, docs, infra
- Group access token (GROUP_TOKEN) stored as group variable
- (Optional) Deploy token (DEPLOY_TOKEN) stored as group variable
- Branch protection for `main` in each project

## How to run
1) Create `terraform.tfvars` (do NOT commit it):
- gitlab_url
- gitlab_token (PAT with api scope)
- group_name
- project_names
- create_deploy_token

2) Init/Apply:
```bash
terraform init
terraform apply
Verification (UI)
Group exists

Projects exist (app/docs/infra)

Group Variables contain GROUP_TOKEN (+ DEPLOY_TOKEN if enabled)

Protected branch main in each project
