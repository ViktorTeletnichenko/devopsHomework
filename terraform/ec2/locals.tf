locals {
  # Naming convention: <project_name>-<enviroment_name>
  name_prefix = "${var.project_name}-${var.enviroment_name}"

  # Resource names based on convention
  instance_name = "${local.name_prefix}-ec2-nginx"
  sg_name       = "${local.name_prefix}-sg-web"

  common_tags = {
    ManagedBy   = "terraform"
    Project     = var.project_name
    Environment = var.enviroment_name
    Owner       = var.enviroment_owner
    Name        = local.instance_name
  }

  # Task 3: if ami_id provided -> use it, else use latest Ubuntu from data
  effective_ami_id = (
    var.ami_id != null && var.ami_id != ""
  ) ? var.ami_id : data.aws_ami.ubuntu[0].id
}
