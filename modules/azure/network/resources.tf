resource "azurerm_virtual_network" "net" {
  resource_group_name = var.azurerm_resource_group
  location            = var.azure_location

  // Set the name for the network name
  name = var.network_name

  // Set up the primary Network CIDR
  address_space = var.address_space

  tags = merge(
    var.tags,
    var.extra_tags
  )
}

// Loop throught the Public Subnets
resource "azurerm_subnet" "public_subnets" {
  for_each = {
    for subnet in var.subnets.public : subnet.name => subnet
  }

  // Resource Group Name - REQUIRED
  resource_group_name = var.azurerm_resource_group

  // Subnet Name
  name = each.value.name

  // Join the network created above; use this module once per network!
  virtual_network_name = azurerm_virtual_network.net.name

  // Subnets
  address_prefixes = tolist(each.value.cidr_block)
}

// Loop throught the Private Subnets
resource "azurerm_subnet" "private_subnets" {
  for_each = {
    for subnet in var.subnets.private : subnet.name => subnet
  }

  // Resource Group Name - REQUIRED
  resource_group_name = var.azurerm_resource_group

  // Subnet Name
  name = each.value.name

  // Join the network created above; use this module once per network!
  virtual_network_name = azurerm_virtual_network.net.name

  // Subnets
  address_prefixes = tolist(each.value.cidr_block)
}
