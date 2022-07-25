// Loop through the VMs to create/manage
resource "azurerm_linux_virtual_machine" "vm" {
  for_each = {
    for node in var.vm_values : node.name => node
  }

  // Azure Required Resources
  resource_group_name = var.azurerm_resource_group
  location            = var.azure_location

  // Set the host name
  name           = each.value.name
  computer_name  = each.value.name
  admin_username = "talos-linux"
  admin_password = "UnusedTalosLinuxPassword!"

  // Additional Values
  disable_password_authentication = "false"
  encryption_at_host_enabled      = "false"
  max_bid_price                   = "-1"

  // Instance Size
  size     = each.value.instance_size
  priority = "Regular"

  // Network Interfaces
  network_interface_ids = [
    azurerm_network_interface.nic[each.value.name].id
  ]

  // Optional Values - Try Logic; not necessary to set
  allow_extension_operations = try(each.value.allow_extension_operations, null) != null ? each.value.allow_extension_operations : "false"
  provision_vm_agent         = try(each.value.provision_vm_agent, null) != null ? each.value.provision_vm_agent : "false"
  vtpm_enabled               = try(each.value.vtpm_enabled, null) != null ? each.value.vtpm_enabled : "false"
  secure_boot_enabled        = try(each.value.secure_boot_enabled, null) != null ? each.value.secure_boot_enabled : "false"

  // Create the OS Disk
  os_disk {
    name                      = "${lower(each.value.name)}-os-disk"
    caching                   = "ReadWrite"
    storage_account_type      = "Standard_LRS"
    write_accelerator_enabled = "false"
    disk_size_gb              = each.value.disk_size_gb
  }

  // Set the Source Image
  source_image_id = data.azurerm_image.search.id

  // VMs depend on the NICs existing
  depends_on = [
    azurerm_network_interface.nic
  ]
}

resource "azurerm_network_interface" "nic" {
  for_each = {
    for node in var.vm_values : node.name => node
  }

  // Azure Required Resources
  resource_group_name = var.azurerm_resource_group
  location            = var.azure_location

  // NIC name
  name = lower("${each.value.name}-nic")

  // Network Settings
  enable_accelerated_networking = "false"
  enable_ip_forwarding          = "true"

  ip_configuration {
    name                          = lower("${each.value.name}-host-eni")
    primary                       = "true"
    private_ip_address_allocation = "Dynamic"
    private_ip_address_version    = "IPv4"
    public_ip_address_id          = try(each.value.public_ip, null) != null ? azurerm_public_ip.pub_ip[each.value.name].id : null
    subnet_id                     = data.azurerm_subnet.list[each.value.name].id
  }

  tags = merge(
    var.tags,
    var.extra_tags
  )
}

resource "azurerm_public_ip" "pub_ip" {
  for_each = {
    for node in var.vm_values : node.name => node
    if lookup(node, "public_ip", null) != null
  }

  // Azure Required Resources
  resource_group_name = var.azurerm_resource_group
  location            = var.azure_location

  // Public IP Settings
  name                    = lower("${each.value.name}-public-ip")
  allocation_method       = "Static"
  zones                   = try(each.value.zones, null) != null ? tolist(each.value.zones) : tolist(["1", "2", "3"])
  idle_timeout_in_minutes = "4"
  ip_version              = "IPv4"
  sku                     = "Standard"
  sku_tier                = "Regional"

  tags = merge(
    var.tags,
    var.extra_tags
  )
}
