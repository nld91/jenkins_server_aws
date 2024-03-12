variable "aws_ec2_user" {
  default = "ec2-user"
}

variable "aws_ami" {
  default = "ami-0fc3317b37c1269d3"
}

variable "aws_instance_type" {
  default = "t2.micro"
}

variable "aws_region" {
  default = "eu-west-1"
}

variable "ssh_public_key_path" {
  default = "~/.ssh/id_rsa.pub"
}

variable "ssh_private_key_path" {
  default = "/home/nld/.ssh/id_rsa"
}