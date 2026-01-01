# HW3 Terraform output

## Commands executed
- terraform init -reconfigure
- terraform plan
- terraform apply -auto-approve
- terraform state list

## Notes
- Remote backend: MinIO S3 (bucket: tfstate, key: gitlab/homework3/terraform.tfstate)
- Credentials used via environment variables: GITLAB_TOKEN, AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY
