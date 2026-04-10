#!/bin/bash
set -e

echo "===== Updating system ====="
sudo apt update -y && sudo apt upgrade -y

echo "===== Installing required packages ====="
sudo apt install -y curl unzip ca-certificates apt-transport-https gnupg lsb-release

# ---------------- AWS CLI ----------------
echo "===== Installing AWS CLI v2 ====="
curl -s "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o awscliv2.zip
unzip -q awscliv2.zip
sudo ./aws/install --update
rm -rf aws awscliv2.zip

# ---------------- kubectl ----------------
echo "===== Installing kubectl ====="
KUBECTL_VERSION=$(curl -L -s https://dl.k8s.io/release/stable.txt)
curl -LO "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/local/bin/

# ---------------- eksctl ----------------
echo "===== Installing eksctl ====="
curl -sL "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" \
| tar xz -C /tmp
sudo mv /tmp/eksctl /usr/local/bin/

# ---------------- Validation ----------------
echo "===== Validating installations ====="
aws --version
kubectl version --client
eksctl version

echo "========================================"
echo "✅ EKS tools installation completed!"
echo "Next step:"
echo "eksctl create cluster --name eks-lab --region us-east-1"
echo "========================================"

2.chmod +x eks-install.sh

3.Verify:
aws --version
kubectl version --client
eksctl version

#4.Attach the IAM Role to the EC2 instance with AdminAccess role.

#5.Verify IAM Role on Terminal:
aws sts get-caller-identity

#6.Create EKS Cluster:

eksctl create cluster \
--name eks-lab \
--region ap-south-1 \
--nodegroup-name eks-nodes \
--node-type t3.medium \
--nodes 2 \
--managed

#Here we didnt mentioned the storage for worker nodes so it will take the default 8gb.
if we terminate the ubuntu machine it wil do not impact on eks cluster.
we can do from anywhere just kubectl should be installed & awscli shoulb be there.
 

#7.Verify Cluster:
kubectl get nodes
