# Terraform/Terragrunt Setup for Multi-Cloud

This repo contains all of the necessary information to get multi cloud [Talos Linux](https://www.talos.dev/) up and going for my [Homelab-kube-Cluster](https://github.com/danmanners/homelab-kube-cluster).

## Developer System Setup

On your development/deployment machine, you'll need several tools and utilities to get everything up and going. This list _may not_ be exhaustive:

- Terraform
- Terragrunt
- AWS CLI / Azure CLI / Google Cloud SDK

## Talos Azure Image Setup

> The docs can be found [here](https://www.talos.dev/v1.1/talos-guides/install/cloud-platforms/azure/#environment-setup), but I'll copy/paste them below for ease of use:

```bash
# Set the version of Talos Linux to download
export TALOS_VERSION="v1.1.1"
# Download the latest image; untar it to retrieve the VHD
wget https://github.com/siderolabs/talos/releases/download/${TALOS_VERSION}/azure-amd64.tar.gz -O ~/Downloads/azure-amd64.tar.gz
tar -xvzf ~/Downloads/azure-amd64.tar.gz
mv disk.vhd azure-talos-${TALOS_VERSION}.vhd

# Storage account to use
export STORAGE_ACCOUNT="StorageAccountName"

# Storage container to upload to
export STORAGE_CONTAINER="StorageContainerName"

# Resource group name
export GROUP="ResourceGroupName"

# Location
export LOCATION="eastus"

# Get storage account connection string based on info above
export CONNECTION=$(az storage account show-connection-string \
                    -n $STORAGE_ACCOUNT \
                    -g $GROUP \
                    -o tsv)

# Upload the VHD
az storage blob upload \
  --connection-string $CONNECTION \
  --container-name $STORAGE_CONTAINER \
  -f ~/Downloads/azure-talos-${TALOS_VERSION}.vhd \
  -n azure-talos-${TALOS_VERSION}.vhd

# Register the Image to Azure
az image create \
  --name "azure-talos-${TALOS_VERSION}" \
  --source https://$STORAGE_ACCOUNT.blob.core.windows.net/$STORAGE_CONTAINER/azure-talos-${TALOS_VERSION}.vhd \
  --os-type linux \
  -g $GROUP
```
