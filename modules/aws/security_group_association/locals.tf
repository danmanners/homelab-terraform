locals {
  sg_attachment = {
    for item in setproduct(
      values(var.security_groups),
      values(var.ec2_enis)
    ): element(item, 0) => element(item, 1)
  }
}