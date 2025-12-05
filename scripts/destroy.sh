#!/bin/bash
set -e

# Move to terraform directory
cd "$(dirname "$0")/../terraform"

echo "WARNING: This will DESTROY ALL AWS resources created by this Terraform project!"
echo "This includes VPC, Subnets, NAT Gateway, EC2, ALB, ASG, IAM roles, CloudWatch Logs, etc."
echo ""
read -p "Type YES to confirm destruction: " confirm

if [ "$confirm" = "YES" ]; then
  echo ""
  echo "Destroying all Terraform-managed resources..."
  terraform destroy -auto-approve
  echo ""
  echo "All resources destroyed successfully!"
else
  echo ""
  echo "Destroy action cancelled."
fi
