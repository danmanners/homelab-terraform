resource "aws_network_interface_sg_attachment" "sg_attachment" {
  // For Each 
  for_each = {
    for item in setproduct(values(var.security_groups), values(var.ec2_enis)) :
    element(item, 1) => element(item, 0)
  }
  network_interface_id = each.key
  security_group_id    = each.value
}
