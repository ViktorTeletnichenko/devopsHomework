output "ubuntu_public_ip" {
  value = aws_instance.ubuntu.public_ip
}

output "rhel_public_ip" {
  value = aws_instance.rhel.public_ip
}
