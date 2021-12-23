resource "aws_network_interface_sg_attachment" "sg_attachment" {
  // For Each 
  for_each = local.sg_attachment
  security_group_id    = each.key
  network_interface_id = each.value
}
