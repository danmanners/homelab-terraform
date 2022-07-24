## Resource Group
resource "azurerm_resource_group" "talos" {
  location = var.azure.location
  name     = var.azure.resource_group_name

  tags = {
    Name    = var.azure.resource_group_name
    project = "Homelab"
    purpose = "Learning"
  }
}

// Create the Azure Network
module "azure_network" {
  source = "./modules/azure/network"

  // Azure Requirements
  azurerm_resource_group = azurerm_resource_group.talos.name
  azure_location         = var.azure.location

  // Networking Settings
  network_name  = "talos-network"
  address_space = var.azure.address_space
  subnets       = var.azure.subnets

  // Tags
  tags = {
    Name    = "Talos Resources"
    project = "Talos"
  }
}

// Create the Security Group for Talos
module "talos_node_security_group" {
  source = "./modules/azure/security_groups"

  // Azure Requirements
  azurerm_resource_group = azurerm_resource_group.talos.name
  azure_location         = var.azure.location

  // Security Group Settings
  security_group_name = "talos-networking"
  security_group_rules = var.azure.security_groups.talos_ingress

  // Tags
  tags = {
    Name    = "Talos Resources"
    project = "Talos"
  }
}