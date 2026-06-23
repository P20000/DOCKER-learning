#!/bin/bash

# Set strict mode (exit on error, unset variables, or failed pipes)
set -euo pipefail

# Color codes for pretty terminal outputs
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}======================================================${NC}"
echo -e "${BLUE}  Starting AWS EC2 Docker Provisioning Sequence      ${NC}"
echo -e "${BLUE}======================================================${NC}"

# Define the TF_DATA_DIR in the home folder to bypass 'noexec' partition limits
export TF_DATA_DIR="$HOME/.terraform-data-learning-docker"

# 1. Check if AWS credentials are set
if [ -z "${AWS_ACCESS_KEY_ID:-}" ] && [ ! -f "$HOME/.aws/credentials" ] && [ ! -f "$HOME/.aws/config" ]; then
    echo -e "${RED}⚠️ WARNING: No AWS credentials detected in environment variables or ~/.aws/ files.${NC}"
    echo -e "${YELLOW}Please ensure your AWS credentials are set before running this script.${NC}\n"
fi

# 2. Initialize Terraform if the local configuration is not set up
if [ ! -d ".terraform" ] || [ ! -d "$TF_DATA_DIR" ]; then
    echo -e "${YELLOW}Initializing Terraform...${NC}"
    terraform init -input=false
fi

# 3. Apply the Terraform configuration
echo -e "${YELLOW}Applying Terraform changes (provisioning AWS resources)...${NC}"
if terraform apply -auto-approve -input=false; then
    echo -e "\n${GREEN}✓ Infrastructure successfully provisioned!${NC}"
    
    # 4. Get the raw output for the SSH command
    SSH_COMMAND=$(terraform output -raw ssh_command)
    
    echo -e "\n${GREEN}==========================================================${NC}"
    echo -e "${GREEN}  SSH COMMAND (Copy & paste to connect):                  ${NC}"
    echo -e "${GREEN}==========================================================${NC}"
    echo -e "${YELLOW}${SSH_COMMAND}${NC}"
    echo -e "${GREEN}==========================================================${NC}"
    echo -e "${BLUE}Info: Docker installation runs on boot and takes 1-2 mins to complete.${NC}\n"
else
    echo -e "\n${RED}❌ Terraform apply failed. See the output logs above for details.${NC}"
    exit 1
fi
