resource "local_file" "inventory" {
  filename = "${path.module}/ansible/inventory.ini"
  content = templatefile("${path.module}/inventory.tmpl", {
    front_public_ip      = aws_instance.front.public_ip
    front_private_ip     = aws_instance.front.private_ip
    backend_public_ip    = aws_instance.backend.public_ip
    backend_private_ip   = aws_instance.backend.private_ip
    ssh_private_key_path = var.ssh_private_key_path
  })
}

resource "local_file" "ansible_cfg" {
  filename = "${path.module}/ansible/ansible.cfg"
  content  = <<-CFG
[defaults]
inventory = ./inventory.ini
host_key_checking = False
remote_user = ubuntu
private_key_file = ${var.ssh_private_key_path}
interpreter_python = auto_silent

[ssh_connection]
pipelining = True
CFG
}
