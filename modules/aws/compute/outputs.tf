output "ipv4" {
  // For Each EC2 Instance, output the IPv4 Address
  value = {
    for k, v in aws_instance.nodes : k => v.public_ip
  }
}

output "primary_net_interface_ids" {
  value = {
    for k, v in aws_instance.nodes : k => v.primary_network_interface_id
  }
}