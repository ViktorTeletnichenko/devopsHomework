variable "group_name" {
  type = string
}

variable "project_names" {
  type = list(string)
}

variable "create_deploy_token" {
  type    = bool
  default = true
}
