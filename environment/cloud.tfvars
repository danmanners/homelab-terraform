cloud_auth = {
  // AWS
  aws_region  = "us-east-1"
  aws_profile = "default"
}

ssh_auth = {
  username  = "danmanners"
  pubkey    = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAngYLcPg5iIOgxoVae6JUr3gyqB4QBufth6oNc+II0D Dan Manners <daniel.a.manners@gmail.com>"
  ssh_rsa   = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCqOmALCT7gw6C0xhW8ig/WqiTCfUckw7tCnFxLl+Uf0jz2MsDz6/QAQ6MWCcl486vtt2lwF5m4GDlWY2u37f259JlWKHtIyaMAAUoGsHdE1SxVZrD9D00j73WPoHoTfV6v4cTNKDr6nmcxlO5wmA4ph6zUoOZyyuhW/MtDgdT+36d8AVjWSCuWA1NiD+o2FekUBbVWvIQ52Q+GM1w67CrqIk3DGl/CVuu/VSAZnQQ971zI8IiQD+Hxj2Et6aOhGhWRBGL45YGUya9c7ZkRn4173YjJC/TQJjORMkzd3o47EcDWK9i8rNm1YfL/EkAa+5N7sV+nMHonNZfBsSfV8l69EVMRTASvp22AArIxpDyMpgHk14IjjrZ2mBi1fATVGqZEYQYv2qMqGx32qPrvGLFwZ6jzumzPvpQIlJEoKE5gF+4KIXGs0OPW0FhWtn22R2hNg+PfD0i86p7iDSE0Fa7bdksvN1Ah9X4gqb0A8EXgvzQ4N/1bfbd2zi9yBKflCi+tW5/6zghO7oFM0aKHR7G6BDPYu8j/dSfprPejOLVSaO3folxerXMvTWc7PXptwNoA54oAze1zNuF3Nu/oeBps2EOXXugCiw/XgKsdWQ5M70EGWEY+NB1IpePX+AwbW+OIx2QC3vi/Pt3tknkmiubFRs9OignhX/V+xyYJQCEOrw== dan@RyzenPC"
}

# google_cloud = {
#   "vpc_name" = "homelab-k3s"
#   "vpc_public_subnets" = {
#     "homelab-public-1a" = {
#       ip_cidr_range = "10.46.0.0/23"
#       description   = "Public facing subnet; first region."
#     }
#   },
#   ingress_rules = {
#     name = "k3s-ingress"
#     direction = "ingress"
#     target_tags = ["k3s"]
#     allow_blocks = {
#       icmp = {
#         protocol = "icmp"
#       }
#       tcp = {
#         protocol = "tcp"
#         ports = ["22","80","443","2222","8443"]
#       }
#     }
#   },
#   compute = [
#     {
#       "name"            = "tpi-k3s-gcp-edge"
#       "zone"            = "a"
#       "vm_type"         = "e2-small"
#       "boot_disk_size"  = 20
#       "host_os"         = "debian-cloud/debian-10"
#       # "host_os"         = "ubuntu-os-cloud/ubuntu-2004-lts"
#       "network"         = {
#         "subnetwork"    = "projects/booming-tooling-291422/regions/us-east4/subnetworks/homelab-public-1a"
#         "tier"          = "standard"
#       }
#       "tags"            = ["k3s"]
#     }
#   ] 
# }

aws = {
  vpc = {
    cidr_block = "172.29.0.0/16"
  }
  subnets = {
    public = {
      "1a" = {
        name        = "1a"
        cidr_block  = "172.29.0.0/24"
      }
    }
  }
  compute = [
    {
      "name"              = "tpi-k3s-aws-edge"
      "instance_size"     = "t3.medium"
      "subnet_id"         = "1a"
      "root_volume_size"  = "24"
    }
  ]
  datestamp = "20210720"
  security_groups = {
    "k3s_ingress" = {
      "name" = "k3s_inbound_traffic"
      "description" = "Allows inbound traffic to the appropriate ports."
      "ingress" = [
        {
          "description" = "ICMP Inbound"
          "port"        = -1
          "protocol"    = "icmp"
          "cidr_blocks" = "0.0.0.0/0"
        },
        {
          "description" = "SSH Inbound"
          "port"        = 22
          "protocol"    = "tcp"
          "cidr_blocks" = "0.0.0.0/0"
        },
        {
          "description" = "HTTP Inbound"
          "port"        = 80
          "protocol"    = "tcp"
          "cidr_blocks" = "0.0.0.0/0"
        },
        {
          "description" = "HTTPS Inbound"
          "port"        = 443
          "protocol"    = "tcp"
          "cidr_blocks" = "0.0.0.0/0"
        },
        {
          "description" = "SSH Alt Inbound"
          "port"        = 2222
          "protocol"    = "tcp"
          "cidr_blocks" = "0.0.0.0/0"
        },
        {
          "description" = "HTTPS Alt Inbound"
          "port"        = 8443
          "protocol"    = "tcp"
          "cidr_blocks" = "0.0.0.0/0"
        }
      ]
    }
  }
  tags = {
    environment   = "homelab"
    project_name  = "k3s-homelab"
  }
}

azure = {
  location = "eastus"
}