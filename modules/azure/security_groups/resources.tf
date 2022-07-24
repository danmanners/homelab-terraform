## Network Security Group for the Public Network
resource "azurerm_network_security_group" "sg" {
  resource_group_name = var.azurerm_resource_group
  location            = var.azure_location

  // Set the name for the security group
  name = var.security_group_name

  tags = merge(
    var.tags,
    var.extra_tags
  )
}

// Loop through and create Security Group rules
resource "azurerm_network_security_rule" "rules" {
  for_each = {
    for rule in var.security_group_rules : rule.name => rule
  }

  // Azure Required Resources
  resource_group_name         = var.azurerm_resource_group
  network_security_group_name = azurerm_network_security_group.sg.name

  // For Each
  name                       = each.value.name
  priority                   = each.value.priority
  direction                  = title(each.value.direction)
  access                     = title(each.value.access)
  protocol                   = title(each.value.protocol)
  source_address_prefix      = each.value.source_address_prefix
  source_port_range          = each.value.source_port_range
  destination_address_prefix = each.value.destination_address_prefix
  destination_port_range     = each.value.destination_port_range
}
