google_cloud = {
  "vpc_name" = "homelab-k3s"
  "vpc_public_subnets" = {
    "homelab-public-1a" = {
      ip_cidr_range = "10.46.0.0/23"
      description   = "Public facing subnet; first region."
    }
  },
  ingress_rules = {
    name = "k3s-ingress"
    direction = "ingress"
    target_tags = ["k3s"]
    allow_blocks = {
      icmp = {
        protocol = "icmp"
      }
      tcp = {
        protocol = "tcp"
        ports = ["22","80","443","2222","8443"]
      }
    }
  },
  compute = [
    {
      "name"            = "tpi-k3s-gcp-edge"
      "zone"            = "a"
      "vm_type"         = "e2-small"
      "boot_disk_size"  = 20
      "host_os"         = "debian-cloud/debian-10"
      # "host_os"         = "ubuntu-os-cloud/ubuntu-2004-lts"
      "network"         = {
        "subnetwork"    = "projects/booming-tooling-291422/regions/us-east4/subnetworks/homelab-public-1a"
        "tier"          = "standard"
      }
      "tags"            = ["k3s"]
    }
  ] 
}
