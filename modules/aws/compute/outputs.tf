output "ipv4" {
  // For Each Droplet, output the IPv4 Address
  value = {
    for k, v in aws_instance.nodes: k => v.public_ip
  }
}

output "primary_net_interface_id" {
  value = {
    for k, v in aws_instance.nodes: k => v.primary_network_interface_id
  }
}