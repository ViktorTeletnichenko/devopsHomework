provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}

resource "aws_security_group" "web" {
  name        = local.sg_name
  description = "Managed by Terraform"
  vpc_id      = data.aws_vpc.default.id

  # SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # App ports (80/443 etc)
  dynamic "ingress" {
    for_each = toset(var.application_ports)
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags, {
    Name = local.sg_name
  })
}

resource "aws_instance" "nginx" {
  ami                    = local.effective_ami_id
  instance_type          = var.instance_type
  subnet_id              = data.aws_subnets.default.ids[0]
  vpc_security_group_ids = [aws_security_group.web.id]
  key_name               = var.key_name

  monitoring = var.monitoring

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 2
    instance_metadata_tags      = "enabled"
  }

  user_data = <<-EOT
    #!/bin/bash
    set -e
    apt-get update -y
    apt-get install -y nginx
    systemctl enable nginx
    systemctl start nginx
  EOT

  root_block_device {
    volume_size = var.root_block_device_size
    volume_type = "gp3"
  }

  ebs_block_device {
    device_name = "/dev/sdf"
    volume_size = var.ebs_size
    volume_type = "gp3"
  }

  tags = local.common_tags

  lifecycle {
    # Preconditions (evaluated before create/update)
    precondition {
      condition     = local.common_tags["Name"] == local.instance_name && startswith(local.instance_name, local.name_prefix)
      error_message = "Name tag does not match naming convention. Expected prefix: ${local.name_prefix}"
    }

    precondition {
      condition     = var.monitoring == true
      error_message = "monitoring must be enabled (true)."
    }

    # Postconditions (evaluated after create/update)
    postcondition {
      condition     = self.monitoring == true
      error_message = "EC2 monitoring is not enabled."
    }

    postcondition {
      condition     = lookup(self.tags, "Owner", "") != ""
      error_message = "EC2 instance must have tag Owner."
    }
  }
}
