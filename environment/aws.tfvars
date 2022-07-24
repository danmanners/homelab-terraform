cloud_auth = {
  // AWS
  aws_region  = "us-east-1"
  aws_profile = "default"
}

aws = {
  vpc = {
    cidr_block = "172.29.0.0/16"
  }
  subnets = {
    public = {
      "1a" = {
        name       = "1a"
        cidr_block = "172.29.0.0/24"
      }
    }
  }
  amd64_compute = [
    {
      "name"             = "tpi-k3s-aws-edge"
      "instance_size"    = "t3.medium"
      "subnet_id"        = "1a"
      "root_volume_size" = "32"
    }
  ]
  arm64_compute = [
    {
      "name"             = "talos-grav1"
      "instance_size"    = "t4g.small"
      "subnet_id"        = "1a"
      "root_volume_size" = "32"
    }
  ]
  datestamp = "20210720"
  k3s_security_groups = {
    "k3s_ingress" = {
      "name"        = "k3s_inbound_traffic"
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
  talos_security_groups = {
    "k3s_ingress" = {
      "name"        = "talos_inbound_traffic"
      "description" = "Allows inbound traffic to the appropriate ports."
      "ingress" = [
        {
          "description" = "ICMP Inbound"
          "port"        = -1
          "protocol"    = "icmp"
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
          "description" = "Talos 6443 Ingress"
          "port"        = 6443
          "protocol"    = "tcp"
          "cidr_blocks" = "0.0.0.0/0"
        },
        {
          "description" = "Talos Wireguard Ingress"
          "port"        = 13231
          "protocol"    = "udp"
          "cidr_blocks" = "0.0.0.0/0"
        },
        {
          "description" = "Talos 50000-50001 Ingress"
          "port"        = null
          "to_port"     = 50000
          "from_port"   = 50001
          "protocol"    = "tcp"
          "cidr_blocks" = "0.0.0.0/0"
        }
      ]
    }
  }
  tags = {
    environment  = "homelab"
    project_name = "k3s-homelab"
  }
}
