variable "region" {
  type    = string
  default = "eu-central-1"
}

variable "profile" {
  type    = string
  default = "myaws"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "allowed_cidr" {
  type    = string
  default = "0.0.0.0/0"
}

variable "key_name" {
  type    = string
  default = "tf-deployer-key"
}

variable "private_key_path" {
  type = string
}
