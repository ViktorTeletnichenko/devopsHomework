resource "gitlab_group" "hw" {
  name             = var.group_name
  path             = var.group_path
  visibility_level = "private"
}

resource "gitlab_project" "hw" {
  name         = var.project_name
  path         = var.project_path
  namespace_id = gitlab_group.hw.id

  initialize_with_readme = true
  visibility_level       = "private"
}

resource "gitlab_group_variable" "hw" {
  group = gitlab_group.hw.id

  key   = var.group_variable_key
  value = var.group_variable_value

  # Якщо буде помилка з masked — поставимо masked=false або змінимо значення
  masked            = true
  protected         = false
  environment_scope = "*"
  variable_type     = "env_var"
}

resource "gitlab_project_access_token" "hw" {
  project      = gitlab_project.hw.id
  name         = var.token_name
  access_level = "maintainer"
  scopes       = ["api"]
  expires_at   = var.token_expires_at
}
