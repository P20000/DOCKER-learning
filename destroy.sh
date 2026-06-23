#!/bin/bash

# Set strict mode
set -euo pipefail

# Color codes
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Define the TF_DATA_DIR to match the one used during creation
export TF_DATA_DIR="$HOME/.terraform-data-learning-docker"

echo -e "${RED}⚠️  WARNING: You are about to destroy the EC2 Docker Host and all its resources.${NC}"
read -p "Are you sure you want to proceed? (y/N) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
    echo -e "${YELLOW}Destroying Terraform-managed infrastructure...${NC}"
    terraform destroy -auto-approve
    echo -e "${YELLOW}Infrastructure destroyed successfully.${NC}"
else
    echo -e "Destroy cancelled."
fi
