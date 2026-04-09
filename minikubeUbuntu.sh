#!/bin/bash

set -e

echo "Updating system..."
sudo apt update -y && sudo apt upgrade -y

echo "Installing dependencies..."
sudo apt install -y curl apt-transport-https ca-certificates

echo "Installing Docker..."
sudo apt install -y docker.io
sudo systemctl enable --now docker

echo "Adding current user to docker group..."
sudo usermod -aG docker $USER

echo "Installing kubectl..."
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/local/bin/

echo "Installing Minikube..."
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube

echo "Verifying installations..."
docker --version
kubectl version --client
minikube version

echo "Starting Minikube..."
minikube start --driver=docker

echo "Checking cluster..."
kubectl get nodes

echo "Done!"
echo "NOTE: You may need to log out and log back in for Docker permissions to take effect."
