data "azurerm_image" "search" {
  resource_group_name = var.azurerm_resource_group
  name_regex          = "talos-${var.talos_version}"
}

data "azurerm_subnet" "list" {
  for_each = {
    for node in var.vm_values : node.name => node
  }

  name                 = each.value.subnet_id
  virtual_network_name = var.network_name
  resource_group_name  = var.azurerm_resource_group
}
