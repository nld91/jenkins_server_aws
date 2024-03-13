#!/bin/bash

# Function to install Ansible and AWS CLI for Debian/Ubuntu
install_ansible_awscli_debian() {
    sudo apt update
    sudo apt install -y ansible awscli
}

# Function to install Ansible and AWS CLI for RHEL/CentOS
install_ansible_awscli_rhel() {
    sudo yum install -y ansible awscli
}

# Function to check if Terraform is already installed
check_terraform_installed() {
    if terraform version &>/dev/null; then
        echo "Terraform is already installed. Skipping Terraform installation."
        return 0
    else
        return 1
    fi
}

# Function to install Terraform on Ubuntu/Debian
install_terraform_debian() {
    if check_terraform_installed; then
        return
    fi
    wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
    sudo apt update && sudo apt install terraform
}

# Function to install Terraform on RHEL/CentOS
install_terraform_rhel() {
    if check_terraform_installed; then
        return
    fi
    sudo yum install -y yum-utils
    sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
    sudo yum -y install terraform
}

# Determine the package manager and install accordingly
if command -v apt >/dev/null; then
    echo "Detected Debian/Ubuntu..."
    install_ansible_awscli_debian
    install_terraform_debian
elif command -v yum >/dev/null; then
    echo "Detected RHEL/CentOS..."
    install_ansible_awscli_rhel
    install_terraform_rhel
else
    echo "Unsupported Linux distribution."
    exit 1
fi

# Check for existing RSA key
if [ ! -f ~/.ssh/id_rsa ]; then
    echo "RSA key not found. Creating one..."
    ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -q -N ""
    echo "RSA key created."
else
    echo "RSA key already exists."
fi

# Begin AWS configuration process
echo "Starting AWS configuration..."
aws configure

echo "Setup complete."
