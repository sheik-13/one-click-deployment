#!/bin/bash
set -e

# Move to terraform directory
cd "$(dirname "$0")/../terraform"

echo "Initializing Terraform backend..."
terraform init

echo ""
echo "Applying Terraform (One-Click Deploy)..."
terraform apply -auto-approve

echo ""

# Fetch ALB DNS output safely
ALB_DNS=$(terraform output -raw alb_dns_name 2>/dev/null || echo "")

echo "Deployment completed successfully!"
echo ""

if [ -n "$ALB_DNS" ]; then
  echo "ALB DNS: http://$ALB_DNS"
  echo ""
  echo "You can test your API using:"
  echo "  curl http://$ALB_DNS/"
  echo "  curl http://$ALB_DNS/health"
else
  echo "ALB DNS output is empty."
  echo "Check all Terraform outputs using:"
  echo "  terraform output"
fi

echo ""
echo "Done!"
