provider "gitlab" {
  base_url = var.gitlab_base_url
  token    = var.gitlab_token
  insecure = var.gitlab_insecure
}
