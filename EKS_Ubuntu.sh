#!/bin/bash
set -e

CLUSTER_NAME="eks-lab"
REGION="ap-south-1"

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
curl -sL https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz \
| tar xz -C /tmp
sudo mv /tmp/eksctl /usr/local/bin/

echo "===== Verify tools ====="
aws --version
kubectl version --client
eksctl version

echo "===== Check IAM ====="
aws sts get-caller-identity

echo "===== Delete old cluster if exists ====="
eksctl delete cluster --region $REGION --name $CLUSTER_NAME || true

echo "===== Create EKS Cluster ====="
eksctl create cluster \
--name $CLUSTER_NAME \
--region $REGION \
--nodegroup-name eks-nodes \
--node-type t3.medium \
--nodes 2 \
--node-volume-size 20 \
--managed

echo "===== Configure kubectl ====="
aws eks update-kubeconfig --region $REGION --name $CLUSTER_NAME

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


#eksctl delete cluster --name eks-lab --region ap-south-1
#aws eks list-clusters --region ap-south-1
#If something is stuck (rare) Delete CloudFormation stacks manually:
#aws cloudformation delete-stack \--stack-name eksctl-eks-lab-cluster \--region ap-south-1
#aws cloudformation delete-stack \--stack-name eksctl-eks-lab-nodegroup-eks-nodes \--region ap-south-1
#
#
#
#
#
#
#
#
#
#
#


