google_cloud = {
  "vpc_name" = "homelab-talos"
  "vpc_public_subnets" = {
    "homelab-public-1a" = {
      ip_cidr_range = "10.46.0.0/23"
      description   = "Public facing subnet"
    }
  },
  ingress_rules = {
    name = "talos-ingress"
    direction = "ingress"
    target_tags = ["talos"]
    allow_blocks = {
      icmp = {
        protocol = "icmp"
      }
      tcp = {
        protocol = "tcp"
        ports = ["80","443","6443","50000","50001"]
      }
    }
  },
  compute = [
    {
      "name"            = "talos-gcp-vm01"
      "zone"            = "a"
      "vm_type"         = "e2-small"
      "boot_disk_size"  = 20
      "host_os"         = "debian-cloud/debian-10"
      "network"         = {
        "subnetwork"    = "projects/booming-tooling-291422/regions/us-east4/subnetworks/homelab-public-1a"
        "tier"          = "standard"
      }
      "tags"            = ["talos"]
    }
  ] 
}
