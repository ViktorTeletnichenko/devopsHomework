output "public_ip" {
  value       = aws_instance.app.public_ip
  description = "Public IP address of the instance"
}

output "public_dns" {
  value       = aws_instance.app.public_dns
  description = "Public DNS name of the instance"
}

output "ssh_user" {
  value       = "ec2-user"
  description = "Default SSH user for Amazon Linux 2"
}
