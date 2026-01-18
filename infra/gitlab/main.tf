module "gitlab_bootstrap" {
  source              = "./modules/gitlab-bootstrap"
  group_name          = var.group_name
  project_names       = var.project_names
  create_deploy_token = var.create_deploy_token
}
