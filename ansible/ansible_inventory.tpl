[jenkins_server]
jenkins-server ansible_ssh_host=${jenkins_public_ip} ansible_ssh_user=${jenkins_server_user} ansible_ssh_private_key_file=${private_key_path} ansible_ssh_common_args='-o StrictHostKeyChecking=no'
