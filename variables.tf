variable "aws_region" {
  type        = string
  description = "The AWS region to deploy the instance into."
  default     = "us-east-1"
}

variable "instance_type" {
  type        = string
  description = "The EC2 instance type."
  default     = "t3.micro"
}

variable "key_name" {
  type        = string
  description = "The name of the key pair and the generated PEM file."
  default     = "docker-ec2-key"
}

variable "allowed_ssh_cidr" {
  type        = list(string)
  description = "CIDR blocks allowed to SSH into the instance. Defaults to everywhere (0.0.0.0/0)."
  default     = ["0.0.0.0/0"]
}

variable "github_repo_url" {
  type        = string
  description = "The GitHub repository to clone on boot for learning and backups."
  default     = "https://github.com/P20000/DOCKER-learning.git"
}
