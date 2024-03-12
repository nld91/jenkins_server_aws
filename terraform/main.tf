resource "null_resource" "output_ip" {
  triggers = {
    ip_address = "${data.http.current_ip.response_body}"
  }
}

resource "aws_security_group" "jenkins_sg" {
  name        = "jenkins-sg"
  description = "Security group for Jenkins server"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${null_resource.output_ip.triggers.ip_address}/32"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["${null_resource.output_ip.triggers.ip_address}/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "jenkins_key_pair" {
  key_name   = "jenkins-key-pair"
  public_key = file(var.ssh_public_key_path)
}

resource "aws_instance" "jenkins_server" {
  ami             = var.aws_ami
  instance_type   = var.aws_instance_type
  key_name        = aws_key_pair.jenkins_key_pair.key_name
  security_groups = [aws_security_group.jenkins_sg.name]
  user_data       = data.template_file.user_data.rendered

}

resource "local_file" "ansible_inventory_file" {
  content  = data.template_file.ansible_inventory.rendered
  filename = "${path.module}/../ansible/inventory.ini"
}

resource "null_resource" "run_ansible_playbook" {
  depends_on = [aws_instance.jenkins_server]

  provisioner "remote-exec" {
    connection {
      host        = aws_instance.jenkins_server.public_dns
      user        = var.aws_ec2_user
      private_key = file(var.ssh_private_key_path)
    }
    inline = ["echo 'Connected to EC2, running playbook!'"]
  }

  provisioner "local-exec" {
    command = "ansible-playbook ../ansible/playbook.yml -i ../ansible/inventory.ini"
  }
}
