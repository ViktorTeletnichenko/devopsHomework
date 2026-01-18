locals {
  name_prefix = "${var.project_name}-${var.enviroment_name}"

  common_tags = {
    Project     = var.project_name
    Environment = var.enviroment_name
    Owner       = var.enviroment_owner
    ManagedBy   = "terraform"
  }
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# Latest Ubuntu (only used when ami_id == "")
data "aws_ami" "ubuntu" {
  count       = var.ami_id == "" ? 1 : 0
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-*-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

locals {
  selected_ami = var.ami_id != "" ? var.ami_id : data.aws_ami.ubuntu[0].id
}

resource "aws_security_group" "front" {
  name        = "${local.name_prefix}-sg-front"
  description = "Front SG (SSH + web)"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "All egress"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-sg-front"
    Role = "front"
  })
}

resource "aws_security_group" "backend" {
  name        = "${local.name_prefix}-sg-backend"
  description = "Backend SG (SSH + DB from front)"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description     = "MariaDB/MySQL from front SG"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.front.id]
  }

  egress {
    description = "All egress"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-sg-backend"
    Role = "backend"
  })
}

resource "aws_instance" "front" {
  ami                    = local.selected_ami
  instance_type          = var.instance_type
  monitoring             = var.monitoring
  subnet_id              = data.aws_subnets.default.ids[0]
  vpc_security_group_ids = [aws_security_group.front.id]
  key_name               = var.key_name

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 2
    instance_metadata_tags      = "enabled"
  }

  root_block_device {
    volume_size = var.root_block_device_size
    volume_type = "gp3"
  }

  ebs_block_device {
    device_name           = "/dev/sdf"
    volume_size           = var.ebs_size
    volume_type           = "gp3"
    delete_on_termination = true
  }

  user_data = <<-EOT
    #!/bin/bash
    set -e
    apt-get update -y
    apt-get install -y python3
  EOT

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-ec2-front"
    Role = "front"
  })

  lifecycle {
    # precondition: тільки перевірка нашої неймінг-конвенції (без self)
    precondition {
      condition     = startswith("${var.project_name}-${var.enviroment_name}-ec2-front", "${var.project_name}-${var.enviroment_name}")
      error_message = "Naming convention broken for front: expected prefix ${var.project_name}-${var.enviroment_name}"
    }

    # postcondition: тут self уже дозволений ✅
    postcondition {
      condition     = startswith(self.tags["Name"], "${var.project_name}-${var.enviroment_name}")
      error_message = "EC2 Name tag must start with ${var.project_name}-${var.enviroment_name}"
    }

    postcondition {
      condition     = self.monitoring == true
      error_message = "EC2 monitoring must be enabled."
    }

    postcondition {
      condition     = try(length(self.tags["Owner"]) > 0, false)
      error_message = "EC2 instance must have tag Owner."
    }
  }
}

resource "aws_instance" "backend" {
  ami                    = local.selected_ami
  instance_type          = var.instance_type
  monitoring             = var.monitoring
  subnet_id              = data.aws_subnets.default.ids[0]
  vpc_security_group_ids = [aws_security_group.backend.id]
  key_name               = var.key_name

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 2
    instance_metadata_tags      = "enabled"
  }

  root_block_device {
    volume_size = var.root_block_device_size
    volume_type = "gp3"
  }

  ebs_block_device {
    device_name           = "/dev/sdf"
    volume_size           = var.ebs_size
    volume_type           = "gp3"
    delete_on_termination = true
  }

  user_data = <<-EOT
    #!/bin/bash
    set -e
    apt-get update -y
    apt-get install -y python3
  EOT

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-ec2-backend"
    Role = "backend"
  })

  lifecycle {
    # precondition: тільки перевірка нашої неймінг-конвенції (без self)
    precondition {
      condition     = startswith("${var.project_name}-${var.enviroment_name}-ec2-backend", "${var.project_name}-${var.enviroment_name}")
      error_message = "Naming convention broken for backend: expected prefix ${var.project_name}-${var.enviroment_name}"
    }

    # postcondition: тут self уже дозволений ✅
    postcondition {
      condition     = startswith(self.tags["Name"], "${var.project_name}-${var.enviroment_name}")
      error_message = "EC2 Name tag must start with ${var.project_name}-${var.enviroment_name}"
    }

    postcondition {
      condition     = self.monitoring == true
      error_message = "EC2 monitoring must be enabled."
    }

    postcondition {
      condition     = try(length(self.tags["Owner"]) > 0, false)
      error_message = "EC2 instance must have tag Owner."
    }
  }
}
