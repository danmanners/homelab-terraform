output "public_subnet_ids" {
  value = { for subnet in azurerm_subnet.public_subnets : subnet.name => subnet.id}
}

output "private_subnet_ids" {
  value = { for subnet in azurerm_subnet.private_subnets : subnet.name => subnet.id}
}
