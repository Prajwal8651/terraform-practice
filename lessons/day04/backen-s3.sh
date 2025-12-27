#!/bin/bash
set -e

BUCKET_NAME="terraform-state-$(date +%s)"
REGION="us-east-1"

echo "Creating S3 bucket in us-east-1..."
echo "Bucket: $BUCKET_NAME"

# Create S3 bucket (correct for us-east-1)
aws s3api create-bucket \
  --bucket "$BUCKET_NAME" \
  --region "$REGION"

# Enable versioning (REQUIRED for Terraform state & S3 native locking)
aws s3api put-bucket-versioning \
  --bucket "$BUCKET_NAME" \
  --versioning-configuration Status=Enabled

# Enable server-side encryption
aws s3api put-bucket-encryption \
  --bucket "$BUCKET_NAME" \
  --server-side-encryption-configuration '{
    "Rules": [
      {
        "ApplyServerSideEncryptionByDefault": {
          "SSEAlgorithm": "AES256"
        }
      }
    ]
  }'

echo "======================================"
echo "S3 Backend Setup Complete!"
echo "======================================"
echo "Bucket Name: $BUCKET_NAME"
echo "Region: us-east-1"
echo "Versioning: Enabled"
echo "Encryption: Enabled (AES256)"
echo ""
echo "State Locking Method: S3 Native State Locking"
echo "  - Uses S3 conditional writes"
echo "  - Creates .tflock files"
echo "  - No DynamoDB required"
echo ""
echo "======================================"
echo "Update your backend.tf with:"
echo "======================================"
echo ""
cat <<EOF
terraform {
  backend "s3" {
    bucket       = "$BUCKET_NAME"
    key          = "dev/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
    encrypt      = true
  }
}
EOF

echo ""
echo "Then run: terraform init"
