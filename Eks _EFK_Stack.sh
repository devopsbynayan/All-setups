#!/bin/bash
set -e

# ======================================================
# EKS Configuration
# ======================================================
CLUSTER_NAME="eks-lab"
REGION="ap-south-1"

# Change this if AWS doesn't offer the instance type
INSTANCE_TYPE="c7i-flex.large"

NODE_COUNT=2
NODE_VOLUME_SIZE=20

echo "===== Update system ====="
sudo apt update -y

echo "===== Install dependencies ====="
sudo apt install -y curl unzip tar

echo "===== Install AWS CLI ====="
curl -s "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o awscliv2.zip
unzip -q awscliv2.zip
sudo ./aws/install --update
rm -rf aws awscliv2.zip

echo "===== Install kubectl ====="
KUBECTL_VERSION=$(curl -s https://dl.k8s.io/release/stable.txt)
curl -LO https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl
chmod +x kubectl
sudo mv kubectl /usr/local/bin/

echo "===== Install eksctl ====="
curl -sL https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz | tar xz -C /tmp
sudo mv /tmp/eksctl /usr/local/bin/

echo "===== Verify tools ====="
aws --version
kubectl version --client
eksctl version

echo "===== Check IAM ====="
aws sts get-caller-identity

echo "===== Delete old cluster if exists ====="
eksctl delete cluster \
  --region $REGION \
  --name $CLUSTER_NAME || true

echo "===== Create EKS Cluster ====="
eksctl create cluster \
  --name $CLUSTER_NAME \
  --region $REGION \
  --nodegroup-name eks-nodes \
  --node-type $INSTANCE_TYPE \
  --nodes $NODE_COUNT \
  --managed \
  --node-volume-size $NODE_VOLUME_SIZE

echo "===== Configure kubectl ====="
aws eks update-kubeconfig \
  --region $REGION \
  --name $CLUSTER_NAME

echo "===== Verify Cluster ====="
kubectl get nodes

echo "===== Enable OIDC ====="
eksctl utils associate-iam-oidc-provider \
  --region $REGION \
  --cluster $CLUSTER_NAME \
  --approve

echo "========================================"
echo "✅ EKS setup completed successfully"
echo "========================================"
echo "=======================================================Modify IAM ROLE==================================================="
