output "name_prefix" {
  value = local.name_prefix
}

output "front_public_ip" {
  value = aws_instance.front.public_ip
}

output "backend_public_ip" {
  value = aws_instance.backend.public_ip
}

output "backend_private_ip" {
  value = aws_instance.backend.private_ip
}

output "front_url" {
  value = "http://${aws_instance.front.public_ip}/index.php"
}

output "inventory_path" {
  value = "${path.module}/ansible/inventory.ini"
}
