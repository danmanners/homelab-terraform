output "sg_attachment" {
  value = {
    for item in setproduct(
      values(var.security_groups),
      values(var.ec2_enis)
    ) : element(item, 1) => element(item, 0)
  }
}
