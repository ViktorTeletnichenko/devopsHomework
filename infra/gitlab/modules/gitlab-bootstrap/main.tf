locals {
  group_path = lower(replace(replace(var.group_name, " ", "-"), "_", "-"))
  projects   = toset(var.project_names)

  project_paths = {
    for n in local.projects :
    n => lower(replace(replace(n, " ", "-"), "_", "-"))
  }
}

resource "gitlab_group" "this" {
  name             = var.group_name
  path             = local.group_path
  visibility_level = "private"
}

resource "gitlab_project" "this" {
  for_each               = local.projects
  name                   = each.value
  path                   = local.project_paths[each.value]
  namespace_id           = gitlab_group.this.id
  initialize_with_readme = true
  default_branch         = "main"
}

resource "gitlab_group_access_token" "group_token" {
  group        = gitlab_group.this.id
  name         = "terraform-group-token"
  scopes       = ["api"]
  access_level = "owner"

  # GitLab у тебе вимагає термін < 1 року
  # і цей ресурс хоче саме DATE (YYYY-MM-DD)
  expires_at = "2026-12-31"
}

resource "gitlab_group_variable" "group_token" {
  group     = gitlab_group.this.id
  key       = "GROUP_TOKEN"
  value     = gitlab_group_access_token.group_token.token
  masked    = false
  protected = false
}

resource "gitlab_deploy_token" "deploy" {
  count = var.create_deploy_token ? 1 : 0

  group  = gitlab_group.this.id
  name   = "terraform-deploy-token"
  scopes = ["read_repository", "read_registry"]

  # Тут провайдер хоче RFC3339 (date-time)
  expires_at = "2030-01-01T00:00:00Z"
}

resource "gitlab_group_variable" "deploy_token" {
  count     = var.create_deploy_token ? 1 : 0
  group     = gitlab_group.this.id
  key       = "DEPLOY_TOKEN"
  value     = gitlab_deploy_token.deploy[0].token
  masked    = false
  protected = false
}

resource "gitlab_branch_protection" "main" {
  for_each = gitlab_project.this

  project                = each.value.id
  branch                 = "main"
  push_access_level      = "maintainer"
  merge_access_level     = "maintainer"
  unprotect_access_level = "maintainer"
}
