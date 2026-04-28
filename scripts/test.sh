#!/bin/bash
set -e

# Move to terraform directory
cd "$(dirname "$0")/../terraform"

# Read ALB DNS output
ALB_DNS=$(terraform output -raw alb_dns_name 2>/dev/null || true)

if [ -z "$ALB_DNS" ]; then
  echo "ERROR: ALB DNS not found."
  echo "Make sure the infrastructure is deployed:"
  echo "  ./scripts/deploy.sh"
  exit 1
fi

echo "Testing API endpoints on ALB: http://$ALB_DNS"
echo ""

# Test root endpoint
echo "GET /"
RESPONSE1=$(curl -s -w "\nStatus: %{http_code}\n" "http://$ALB_DNS/")
echo "$RESPONSE1"
echo ""

# Test health endpoint
echo "GET /health"
RESPONSE2=$(curl -s -w "\nStatus: %{http_code}\n" "http://$ALB_DNS/health")
echo "$RESPONSE2"
echo ""

echo "API test completed successfully!"
echo ""
