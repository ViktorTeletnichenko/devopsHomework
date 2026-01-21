variable "aws_region" {
  type        = string
  description = "AWS region to deploy into"
  default     = "us-east-1"
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type"
  default     = "t3.micro"
}

variable "instance_name" {
  type        = string
  description = "Name tag for the EC2 instance"
  default     = "python-app-ci"
}

variable "key_name" {
  type        = string
  description = "EC2 key pair name"
}

variable "public_key" {
  type        = string
  description = "Public SSH key material for the EC2 key pair"
  sensitive   = true
}

variable "app_port" {
  type        = number
  description = "Port for the python app"
  default     = 8080
}

variable "ssh_ingress_cidr" {
  type        = string
  description = "CIDR allowed to SSH into the instance"
  default     = "0.0.0.0/0"
}
