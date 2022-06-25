#########################################################################
### Networking
// Create the cloud network stack
module "aws_vpc" {
  // Module Source
  source = "./modules/aws/vpc"

  // Networking Settings
  cidr_block = var.aws.vpc.cidr_block
  subnets    = var.aws.subnets
  tags       = var.aws.tags
}

#########################################################################
### Virtual Machines
// Create the amd64 Architecture AWS EC2 Instances
module "aws_compute_amd64" {
  // Module Source
  source = "./modules/aws/compute"
  // Compute Settings
  compute_nodes  = var.aws.amd64_compute
  public_subnets = module.aws_vpc.public_subnets
  ssh_auth       = var.ssh_auth
  architecture   = "amd64"
  datestamp      = var.aws.datestamp
  tags           = var.aws.tags

  // Depends On the AWS VPC being ready
  depends_on = [
    module.aws_vpc
  ]
}

// Create the arm64 Architecture AWS EC2 Instances
module "aws_wireguard_arm64" {
  // Module Source
  source = "./modules/aws/compute"
  // Compute Settings
  compute_nodes  = var.aws.arm64_compute
  public_subnets = module.aws_vpc.public_subnets
  ssh_auth       = var.ssh_auth
  architecture   = "arm64"
  ami            = "ami-01b74c1b9e3142abd"
  datestamp      = var.aws.datestamp
  tags           = var.aws.tags

  // Depends On the AWS VPC being ready
  depends_on = [
    module.aws_vpc
  ]
}

#########################################################################
## K3s
### Security Groups
module "aws_k3s_security_groups" {
  // Module Source
  source          = "./modules/aws/security_groups"
  vpc_id          = module.aws_vpc.vpc_id
  security_groups = var.aws.k3s_security_groups
  tags            = var.aws.tags
}

### Security Group Association
module "aws_k3s_security_group_association" {
  // Module Source
  source = "./modules/aws/security_group_association"

  // Load in Security Groups and ENIs
  security_groups = module.aws_k3s_security_groups.security_group_ids
  ec2_enis = merge(
    module.aws_compute_amd64.primary_net_interface_ids,
  )

  depends_on = [
    module.aws_compute_amd64,
    module.aws_k3s_security_groups
  ]
}

## Talos
### Security Groups
module "aws_talos_security_groups" {
  // Module Source
  source          = "./modules/aws/security_groups"
  vpc_id          = module.aws_vpc.vpc_id
  security_groups = var.aws.talos_security_groups
  tags            = var.aws.tags
}

### Security Group Association
module "aws_talos_security_group_association" {
  // Module Source
  source = "./modules/aws/security_group_association"

  // Load in Security Groups and ENIs
  security_groups = module.aws_talos_security_groups.security_group_ids
  ec2_enis = merge(
    module.aws_wireguard_arm64.primary_net_interface_ids,
  )

  depends_on = [
    module.aws_wireguard_arm64,
    module.aws_talos_security_groups
  ]
}

#########################################################################
### KMS for SOPS
resource "aws_kms_key" "sops" {
  description              = "Dan Manners Homelab SOPS"
  key_usage                = "ENCRYPT_DECRYPT"
  customer_master_key_spec = "SYMMETRIC_DEFAULT"
  deletion_window_in_days  = 14
  is_enabled               = true
  tags = merge(
    {
      Name = "Dan Manners Homelab - SOPS"
    },
    var.aws.tags
  )
}

#########################################################################
### Static Hosted Website - danmanners.com
module "aws_static_website_danmanners" {
  ## Module Source
  source = "./modules/aws/static_s3_website"

  ## Load in Variables
  root_domain         = "danmanners.com"
  domain_name         = "danmanners.com"
  subject_alt_names   = ["www.danmanners.com"]
  all_route53_records = ["www", "."]
}

### Static Hosted Website - resume.danmanners.com
module "aws_static_website_resume_danmanners" {
  ## Module Source
  source = "./modules/aws/static_s3_website"

  ## Load in Variables
  root_domain         = "danmanners.com"
  domain_name         = "resume.danmanners.com"
  all_route53_records = ["resume"]
}
