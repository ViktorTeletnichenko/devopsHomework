output "public_ip" {
  value = aws_instance.nginx.public_ip
}

output "nginx_url" {
  value = "http://${aws_instance.nginx.public_ip}/"
}

output "name_prefix" {
  value = local.name_prefix
}
