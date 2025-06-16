#!/bin/bash

# Set the desired Helm version
export DESIRED_VERSION="v3.15.0"

# Download the official Helm installation script
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3

# Make the script executable
chmod 700 get_helm.sh

# Run the install script (installs the desired version)
./get_helm.sh

# Verify the installed Helm version
helm version
