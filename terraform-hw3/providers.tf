provider "gitlab" {
  base_url = var.gitlab_base_url
  # token беремо з ENV: GITLAB_TOKEN
}
