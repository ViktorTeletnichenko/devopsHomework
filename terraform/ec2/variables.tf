variable "aws_region" {
  type        = string
  description = "AWS region"
  default     = "eu-central-1"
}

variable "aws_profile" {
  type        = string
  description = "AWS CLI profile name"
  default     = "myaws"
}

variable "project_name" {
  type        = string
  description = "Project name used in naming convention"
  validation {
    condition     = length(var.project_name) > 5
    error_message = "project_name must be longer than 5 characters."
  }
}

variable "enviroment_name" {
  type        = string
  description = "Environment name (dev/uat/prod)"
  validation {
    condition     = contains(["dev", "uat", "prod"], var.enviroment_name)
    error_message = "enviroment_name must be one of: dev, uat, prod."
  }
}

variable "enviroment_owner" {
  type        = string
  description = "Owner email for tagging and accountability"
  validation {
    condition     = can(regex("^[^@\\s]+@[^@\\s]+\\.[^@\\s]+$", var.enviroment_owner))
    error_message = "enviroment_owner must be a valid email."
  }
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type (only t* types allowed)"
  default     = "t3.micro"
  validation {
    condition     = startswith(var.instance_type, "t")
    error_message = "instance_type must start with 't' (only t-types allowed)."
  }
}

variable "monitoring" {
  type        = bool
  description = "Enable detailed monitoring (must be true)"
  default     = true
  validation {
    condition     = var.monitoring == true
    error_message = "monitoring must be true."
  }
}

variable "root_block_device_size" {
  type        = number
  description = "Root volume size in GB (>=10 and <30)"
  default     = 10
  validation {
    condition     = var.root_block_device_size >= 10 && var.root_block_device_size < 30
    error_message = "root_block_device_size must be >= 10 and < 30."
  }
}

variable "ebs_size" {
  type        = number
  description = "Additional EBS volume size in GB (>=10 and <30)"
  default     = 10
  validation {
    condition     = var.ebs_size >= 10 && var.ebs_size < 30
    error_message = "ebs_size must be >= 10 and < 30."
  }
}

variable "application_ports" {
  type        = list(number)
  description = "Application ports to allow inbound (1..65535). 80/443 required for nginx/https"
  default     = [80, 443]
  validation {
    condition     = alltrue([for p in var.application_ports : p >= 1 && p <= 65535])
    error_message = "application_ports must be in range 1..65535."
  }
}

variable "key_name" {
  type        = string
  description = "Existing EC2 Key Pair name"
  default     = "tf-deployer-key"
}

variable "ami_id" {
  type        = string
  description = "Optional AMI ID. If empty/null -> latest Ubuntu will be used."
  default     = null
  validation {
    condition = (
      var.ami_id == null || var.ami_id == "" ||
      can(regex("^ami-[0-9a-f]{8,17}$", var.ami_id))
    )
    error_message = "ami_id must match AWS AMI format: ami-xxxxxxxx or ami-xxxxxxxxxxxxxxxxx"
  }
}
