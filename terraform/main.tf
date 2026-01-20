# Ubuntu 24.04 LTS AMI (eu-central-1)
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# RHEL 9 AMI (eu-central-1)
data "aws_ami" "rhel" {
  most_recent = true
  owners      = ["309956199498"] # Red Hat

  filter {
    name   = "name"
    values = ["RHEL-9.*x86_64*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "ubuntu" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  subnet_id              = tolist(data.aws_subnets.default.ids)[0]
  vpc_security_group_ids = [aws_security_group.lemp.id]
  key_name               = var.key_name

  monitoring = true

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  root_block_device {
    volume_size = 10
    volume_type = "gp3"
  }

  user_data = file("${path.module}/userdata/ubuntu.sh")

  tags = {
    Name = "lemp-ubuntu"
    OS   = "Ubuntu"
  }
}

resource "aws_instance" "rhel" {
  ami                    = data.aws_ami.rhel.id
  instance_type          = var.instance_type
  subnet_id              = tolist(data.aws_subnets.default.ids)[0]
  vpc_security_group_ids = [aws_security_group.lemp.id]
  key_name               = var.key_name

  monitoring = true

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  root_block_device {
    volume_size = 10
    volume_type = "gp3"
  }

  user_data = file("${path.module}/userdata/rhel.sh")

  tags = {
    Name = "lemp-rhel"
    OS   = "RedHat"
  }
}
