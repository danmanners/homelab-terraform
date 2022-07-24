azure = {
  resource_group_name = "talos"
  location            = "eastus"
  address_space = [
    "10.91.0.0/16"
  ]

  subnets = {
    public = {
      "public1" = {
        name = "public1"
        cidr_block = [
          "10.91.0.0/24"
        ]
      }
    }
    private = {}
  }

  security_groups = {
    "talos_ingress" = [
      {
        name                       = "icmp_inbound"
        access                     = "Allow"
        direction                  = "Inbound"
        priority                   = "101"
        protocol                   = "Icmp"
        source_address_prefix      = "*"
        source_port_range          = "*"
        destination_address_prefix = "*"
        destination_port_range     = "*"
      },
      {
        name                       = "http_inbound"
        access                     = "Allow"
        direction                  = "Inbound"
        priority                   = "101"
        protocol                   = "Tcp"
        source_address_prefix      = "*"
        source_port_range          = "*"
        destination_address_prefix = "*"
        destination_port_range     = "80"
      },
      {
        name                       = "https_inbound"
        access                     = "Allow"
        direction                  = "Inbound"
        priority                   = "101"
        protocol                   = "Tcp"
        source_address_prefix      = "*"
        source_port_range          = "*"
        destination_address_prefix = "*"
        destination_port_range     = "443"
      },
      {
        name                       = "talos_6443_inbound"
        access                     = "Allow"
        direction                  = "Inbound"
        priority                   = "100"
        protocol                   = "Tcp"
        source_address_prefix      = "*"
        source_port_range          = "*"
        destination_address_prefix = "*"
        destination_port_range     = "6443"
      },
      {
        name                       = "talos_wireguard_inbound"
        access                     = "Allow"
        direction                  = "Inbound"
        priority                   = "100"
        protocol                   = "Udp"
        source_address_prefix      = "*"
        source_port_range          = "*"
        destination_address_prefix = "*"
        destination_port_range     = "13231"
      },
      {
        name                       = "talos_mgmt_inbound"
        access                     = "Allow"
        direction                  = "Inbound"
        priority                   = "100"
        protocol                   = "Tcp"
        source_address_prefix      = "*"
        source_port_range          = "*"
        destination_address_prefix = "*"
        destination_port_range     = "50000-50001"
      },
      {
        name                       = "permit_egress"
        access                     = "Allow"
        direction                  = "Outbound"
        priority                   = "100"
        protocol                   = "*"
        source_address_prefix      = "*"
        source_port_range          = "*"
        destination_address_prefix = "*"
        destination_port_range     = "*"
      },
    ]
  }

  compute = [
    {
      name = "talos-azure-vm01"
    }
  ]
}
