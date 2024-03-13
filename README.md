

# Jenkins Server on AWS with Terraform and Ansible

This repository provides the necessary tools and configurations for setting up a Jenkins server on an AWS EC2 instance. Using Terraform, we provision the server, security group, and key pair, and configure it with Ansible. Additionally, a bash script is included to prepare your development environment, ensuring all prerequisites are met for either Ubuntu/Debian or RHEL/CentOS systems.

  

## Requirements

 - An AWS account with permissions to create EC2 instances, security
   groups, and key pairs.
   
  - A Linux-based system (Ubuntu/Debian or RHEL/CentOS) for running the
   setup scripts.

## Getting Started

Clone this repository to your local machine:

    git clone https://github.com/nld91/jenkins_server_aws.git

    cd jenkins-server-aws-terraform

Run the included bash script to install necessary packages (Ansible, AWS CLI, etc.) on your local machine. This script detects your operating system and installs the appropriate packages (you may need to add execute permissions).

    sudo chmod +x ./dev_env.sh
    ./dev_env.sh

Configure AWS CLI with your credentials. The script will prompt you to enter your AWS access key ID, secret access key, region, and output format.

## Deploying Jenkins on AWS

Initialize Terraform to download necessary plugins and prepare the working directory:

    terraform init

(Optional) Generate a plan to see the resources Terraform will create/manage:

    terraform plan

Apply the Terraform configuration to provision and configure your Jenkins server on AWS:

    terraform apply

When prompted, confirm the action by typing **yes**.

The Terraform configuration will:

  

- Provision an EC2 instance and a security group.

- Generate a key pair for SSH access (if one does not already exist in ~/.ssh/id_rsa).

- Create an Ansible inventory file dynamically.

- Run the Ansible playbook to configure the Jenkins server.

## Security

The configuration is set up to allow SSH (port 22) and Jenkins web interface access (port 8080) only from the IP address of the machine where the Terraform script is run.
 

## Accessing Your Jenkins Server

After the deployment is complete, access your Jenkins server by navigating to:

    http://<EC2_Instance_Public_IP>:8080

Complete the initial setup as prompted by the Jenkins web interface.

  
## Contributions

Contributions are welcome! If you have improvements or bug fixes, please submit a pull request or open an issue.

  

## License

This project is licensed under the MIT License - see the LICENSE.md file for details.