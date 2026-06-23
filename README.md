# Terraform Docker EC2 Host

This Terraform configuration provisions a single AWS EC2 instance running Ubuntu 24.04 LTS, automatically installs the latest Docker Engine (with the Docker Compose plugin), configures the default `ubuntu` user with docker group permissions (no `sudo` required for docker commands), and outputs the ready-to-use SSH terminal command.

## Architecture & Features

- **Automated Key Pair Generation:** A local private TLS key is generated dynamically in Terraform, registered on AWS as an EC2 Key Pair, and saved locally as a `.pem` file.
- **Strict File Permissions:** The local `.pem` file is written with `0400` permissions (read-only for the owner), preventing SSH from rejecting the key.
- **Automatic Docker Installation:** Through EC2 `user_data`, Docker is installed automatically using Docker's official Ubuntu repository, and the `ubuntu` user is added to the `docker` group.
- **Dynamic AMI Lookup:** Automatically finds the latest official Ubuntu 24.04 LTS HVM AMI in the configured region.
- **Clean Security Group:** Open to incoming SSH (port 22) and allows all outbound internet traffic.

---

## Quick Start

### 1. Configure AWS Credentials

Ensure you have your AWS credentials configured in your environment:

```bash
export AWS_ACCESS_KEY_ID="your_access_key"
export AWS_SECRET_ACCESS_KEY="your_secret_key"
# Optionially set a session token if using temporary credentials
# export AWS_SESSION_TOKEN="your_session_token"
```

### 2. Initialize and Deploy

Since this project resides on a mounted partition that may restrict execution permissions (`noexec`), you must initialize and validate Terraform by pointing the provider plugins directory to your home folder:

```bash
# 1. Export the data directory to bypass noexec restrictions on external mounts
export TF_DATA_DIR="$HOME/.terraform-data-learning-docker"

# 2. Initialize Terraform
terraform init

# 3. Plan the changes (Verify resources to be created)
terraform plan

# 4. Apply the configuration (Type 'yes' when prompted)
terraform apply
```

### 3. Connect to the EC2 Instance

Once `terraform apply` finishes successfully, it will print the generated SSH command. Copy and paste it directly into your terminal:

```bash
# Example SSH output:
ssh -i docker-ec2-key.pem ubuntu@<instance_public_ip>
```

> [!NOTE]
> It can take **1–2 minutes** after the instance starts for the `user_data` script to finish installing Docker. If `docker` is not immediately available, wait a moment and try again.

### 4. Clean Up

To destroy the infrastructure and automatically delete the local private key file, run:

```bash
export TF_DATA_DIR="$HOME/.terraform-data-learning-docker"
terraform destroy
```

---

## Configuration Variables

You can customize the deployment by creating a `terraform.tfvars` file or passing variables on the command line:

| Variable | Description | Default |
|----------|-------------|---------|
| `aws_region` | The AWS region to deploy the instance into | `"us-east-1"` |
| `instance_type` | The EC2 instance type | `"t3.micro"` |
| `key_name` | The name of the AWS key pair and local PEM file | `"docker-ec2-key"` |
| `allowed_ssh_cidr` | CIDR blocks allowed to SSH into the instance | `["0.0.0.0/0"]` |
