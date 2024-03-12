data "http" "current_ip" {
  url = "https://api.ipify.org"
}

data "template_file" "ansible_inventory" {
  template = file("${path.module}/../ansible/ansible_inventory.tpl")

  vars = {
    jenkins_public_ip   = aws_instance.jenkins_server.public_ip
    jenkins_server_user = "ec2-user"
    private_key_path    = var.ssh_private_key_path
  }
}

data "template_file" "user_data" {
  template = <<-EOF
        #!/bin/bash
        echo "${file(var.ssh_public_key_path)}" >> /home/ec2-user/.ssh/authorized_keys
        chmod 600 /home/ec2-user/.ssh/authorized_keys
        sudo yum install -y ansible
    EOF
}

