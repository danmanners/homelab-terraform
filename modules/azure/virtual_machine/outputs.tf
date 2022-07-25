output "ipv4" {
  // For Each VM, output the IPv4 Address
  value = {
    for k, v in azurerm_linux_virtual_machine.vm : k => v.public_ip_address
  }
}
