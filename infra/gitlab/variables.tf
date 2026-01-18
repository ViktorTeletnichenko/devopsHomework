variable "gitlab_base_url" {
  type        = string
  description = "GitLab API base url, e.g. http://192.168.0.131/api/v4/"
}

variable "gitlab_token" {
  type        = string
  sensitive   = true
  description = "GitLab Personal Access Token (scope: api)"
}

variable "gitlab_insecure" {
  type        = bool
  default     = false
  description = "true only for https with self-signed certs"
}

variable "group_name" {
  type        = string
  description = "GitLab group name"
}

variable "project_names" {
  type        = list(string)
  description = "Projects to create in the group"
}

variable "create_deploy_token" {
  type        = bool
  default     = true
  description = "Create deploy token and group variable DEPLOY_TOKEN"
}
