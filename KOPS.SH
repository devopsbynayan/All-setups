#!/bin/bash

# Download latest kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

# Get latest kops version and download
KOPS_VERSION=$(curl -s https://api.github.com/repos/kubernetes/kops/releases/latest | grep tag_name | cut -d '"' -f 4)
wget https://github.com/kubernetes/kops/releases/download/${KOPS_VERSION}/kops-linux-amd64

# Make executables
chmod +x kubectl kops-linux-amd64

# Move to /usr/local/bin
mv kubectl /usr/local/bin/kubectl
mv kops-linux-amd64 /usr/local/bin/kops

# Add to PATH if not already present
if ! echo $PATH | grep -q "/usr/local/bin"; then
  echo 'export PATH=$PATH:/usr/local/bin' >> ~/.bashrc
  source ~/.bashrc
fi

# Create S3 bucket (replace with your unique bucket name)
BUCKET_NAME="nayanjain123-$(date +%s)"
aws s3api create-bucket --bucket $BUCKET_NAME --region ap-south-1 --create-bucket-configuration LocationConstraint=ap-south-1

# Enable versioning
aws s3api put-bucket-versioning --bucket $BUCKET_NAME --region ap-south-1 --versioning-configuration Status=Enabled

# Export KOPS_STATE_STORE
export KOPS_STATE_STORE=s3://$BUCKET_NAME
echo "export KOPS_STATE_STORE=s3://$BUCKET_NAME" >> ~/.bashrc

# Create kops cluster
kops create cluster --name nayan.k8s.local --zones ap-south-1a --master-count=1 --master-size t2.medium --node-count=2 --node-size t2.micro

# Apply cluster changes and get admin access
kops update cluster --name nayan.k8s.local --yes --admin

# Validate cluster
kops validate cluster --wait 10m
