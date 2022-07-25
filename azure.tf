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
  network_name  = var.azure.network_name
  address_space = var.azure.address_space
  subnets       = var.azure.subnets

  // Tags
  tags = {
    Name    = "Talos Resources"
    project = "Talos"
  }
}

// Create the Security Group for Talos
module "azure_talos_node_security_group" {
  source = "./modules/azure/security_groups"

  // Azure Requirements
  azurerm_resource_group = azurerm_resource_group.talos.name
  azure_location         = var.azure.location

  // Security Group Settings
  security_group_name  = "talos-networking"
  security_group_rules = var.azure.security_groups.talos_ingress

  // Tags
  tags = {
    Name    = "Talos Resources"
    project = "Talos"
  }
}

// Create the VMs
module "azure_talos_vms" {
  source = "./modules/azure/virtual_machine"

  // Azure Requirements
  azurerm_resource_group = azurerm_resource_group.talos.name
  azure_location         = var.azure.location

  // VM Settings
  vm_values = var.azure.compute
  // Subnet Lookups
  network_name  = var.azure.network_name
  // Talos Version
  talos_version = var.azure.talos_version

  // Tags
  tags = {
    Name    = "Talos Resources"
    project = "Talos"
  }
}

resource "azurerm_subnet_network_security_group_association" "public" {
  for_each = var.azure.subnets.public
  subnet_id = lookup(module.azure_network.public_subnet_ids, each.key)
  network_security_group_id = module.azure_talos_node_security_group.security_group_id
}