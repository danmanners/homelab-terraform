// Print the DigitalOcean Droplet Public IPs
# output "digitalocean_droplet_ips" {
#   value = module.droplets.ipv4
# }

# output "aws_cloud_ips" {
#   value = merge(
#     module.aws_compute_amd64.ipv4,
#     # module.aws_compute_graviton.ipv4
#   )
# }

# output "azure_cloud_ips" {
#   value = {
#     var.azure.compute.*.name[0] = azurerm_public_ip.k3s_vm.ip_address
#   }
# }

output "talos_cloud_ips" {
  value = merge(
    module.aws_wireguard_arm64.ipv4
  )
}
