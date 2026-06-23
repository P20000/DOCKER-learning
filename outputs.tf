output "instance_public_ip" {
  description = "The public IP of the EC2 instance"
  value       = aws_instance.docker_host.public_ip
}

output "private_key_path" {
  description = "The local path to the private key file"
  value       = local_sensitive_file.private_key_file.filename
}

output "ssh_command" {
  description = "Copy and paste this command to SSH into the EC2 instance"
  value       = "ssh -i ${local_sensitive_file.private_key_file.filename} ubuntu@${aws_instance.docker_host.public_ip}"
}
