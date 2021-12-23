output "security_group_ids" {
  // For Each Droplet, output the IPv4 Address
  value = {
    for k, v in aws_security_group.sg: k => v.id
  }
}
