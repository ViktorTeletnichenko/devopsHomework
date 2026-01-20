resource "local_file" "ansible_inventory" {
  filename = "${path.module}/../ansible/inventory.ini"
  content = templatefile("${path.module}/inventory.tmpl", {
    ubuntu_public_ip = aws_instance.ubuntu.public_ip
    rhel_public_ip   = aws_instance.rhel.public_ip
    private_key_path = var.private_key_path
  })
}
