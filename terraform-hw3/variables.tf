variable "gitlab_base_url" {
  type        = string
  description = "Напр: https://192.168.0.131/api/v4/"
}

variable "group_name" { type = string }
variable "group_path" { type = string }

variable "project_name" { type = string }
variable "project_path" { type = string }

variable "group_variable_key" { type = string }
variable "group_variable_value" {
  type      = string
  sensitive = true
}

variable "token_name" { type = string }
variable "token_expires_at" {
  type        = string
  description = "YYYY-MM-DD"
}
