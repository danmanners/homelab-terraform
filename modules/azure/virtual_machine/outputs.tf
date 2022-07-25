output "ipv4" {
  // For Each VM, output the IPv4 Address
  value = {
    for k, v in azurerm_public_ip.pub_ip : k => v.ip_address
  }
}
