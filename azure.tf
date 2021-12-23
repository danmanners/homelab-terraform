## Resource Group
resource "azurerm_resource_group" "homelab_learning" {
  location = var.azure.location
  name     = "homelab-learning"

  tags = {
    Name    = "homelab-learning"
    project = "Homelab"
    purpose = "Learning"
  }
}

## Network Security Group for the Public Network
resource "azurerm_network_security_group" "k3s_ingress_security_group" {
  resource_group_name = azurerm_resource_group.homelab_learning.name
  location            = var.azure.location
  name                = "homelab-learning-k3s_ingress"

  # Allow ICMP Inbound
  security_rule {
    access                     = "Allow"
    direction                  = "Inbound"
    name                       = "icmp_inbound"
    priority                   = "103"
    protocol                   = "Icmp"
    source_address_prefix      = "*"
    source_port_range          = "*"
    destination_address_prefix = "*"
    destination_port_range     = "*"
  }

  # Allow TCP/22 (SSH) Inbound
  security_rule {
    access                     = "Allow"
    direction                  = "Inbound"
    name                       = "ssh_22_inbound"
    priority                   = "100"
    protocol                   = "Tcp"
    source_address_prefix      = "*"
    source_port_range          = "*"
    destination_address_prefix = "*"
    destination_port_range     = "22"
  }

  # Allow TCP/80 (HTTP) Inbound
  security_rule {
    access                     = "Allow"
    direction                  = "Inbound"
    name                       = "http_80_inbound"
    priority                   = "101"
    protocol                   = "Tcp"
    source_address_prefix      = "*"
    source_port_range          = "*"
    destination_address_prefix = "*"
    destination_port_range     = "80"
  }

  # Allow TCP/443 (HTTPS) Inbound
  security_rule {
    access                     = "Allow"
    direction                  = "Inbound"
    name                       = "https_443_inbound"
    priority                   = "102"
    protocol                   = "Tcp"
    source_address_prefix      = "*"
    source_port_range          = "*"
    destination_address_prefix = "*"
    destination_port_range     = "443"
  }

  # Permit all outbound traffic
  security_rule {
    access                     = "Allow"
    direction                  = "Outbound"
    name                       = "traffic_outbound"
    priority                   = "100"
    protocol                   = "*"
    source_address_prefix      = "*"
    source_port_range          = "*"
    destination_address_prefix = "*"
    destination_port_range     = "*"
  }

  tags = {
    project = "Homelab"
    purpose = "Learning"
  }
}

## Virtual Network
resource "azurerm_virtual_network" "cloud_homelab" {
  resource_group_name = azurerm_resource_group.homelab_learning.name
  location            = var.azure.location
  address_space       = ["10.91.0.0/16"]
  name                = "Cloud-Homelab"

  subnet {
    name           = "public1"
    address_prefix = "10.91.0.0/24"
    security_group = azurerm_network_security_group.k3s_ingress_security_group.id
  }

  tags = {
    project      = "Homelab"
    project-name = "homelab-learning"
    purpose      = "Learning"
  }

  depends_on = [
    azurerm_network_security_group.k3s_ingress_security_group
  ]
}

## Public IP Address for K3s VM
resource "azurerm_public_ip" "k3s_vm" {
  resource_group_name     = azurerm_resource_group.homelab_learning.name
  location                = var.azure.location
  name                    = "tpi-k3s-azure-edge-public-ip"
  allocation_method       = "Static"
  availability_zone       = "Zone-Redundant"
  idle_timeout_in_minutes = "4"
  ip_version              = "IPv4"
  sku                     = "Standard"
  sku_tier                = "Regional"

  tags = {
    Name    = "homelab-learning-public-ip"
    project = "Homelab"
    purpose = "Learning"
  }
}

## K3s VM Network Interface
resource "azurerm_network_interface" "k3s_vm_nic" {
  resource_group_name = azurerm_resource_group.homelab_learning.name
  location            = var.azure.location
  name                = "Cloud-Homelab-tpi-k3s-azure-edge-nic"

  enable_accelerated_networking = "false"
  enable_ip_forwarding          = "true"

  ip_configuration {
    name                          = "k3s-host-eni"
    primary                       = "true"
    private_ip_address_allocation = "Dynamic"
    private_ip_address_version    = "IPv4"
    public_ip_address_id          = azurerm_public_ip.k3s_vm.id
    subnet_id                     = azurerm_virtual_network.cloud_homelab.subnet.*.id[0]
  }

  tags = {
    Name    = "homelab-learning-k3s-host-eni"
    project = "Homelab"
    purpose = "Learning"
  }
}

## K3s VM VM Disk
resource "azurerm_managed_disk" "tpi-k3s-azure-edge_disk1_70a4f4157fd847dc91d8c5a76b3840fe" {
  resource_group_name           = upper(azurerm_resource_group.homelab_learning.name)
  location                      = var.azure.location
  name                          = "tpi-k3s-azure-edge_disk1_70a4f4157fd847dc91d8c5a76b3840fe"
  # Create the disk from the Ubuntu Focal Image
  create_option                 = "FromImage"
  image_reference_id            = "/Subscriptions/723f5558-8ae1-4d65-aedb-e4a48a9b7ea2/Providers/Microsoft.Compute/Locations/eastus/Publishers/canonical/ArtifactTypes/VMImage/Offers/0001-com-ubuntu-server-focal/Skus/20_04-lts-gen2/Versions/20.04.202107200"
  # Disk Size
  disk_size_gb                  = "32"
  # R/W IOPS
  disk_iops_read_write          = "500"
  disk_mbps_read_write          = "60"
  hyper_v_generation            = "V2"
  # max_shares                    = "0"
  os_type                       = "Linux"
  public_network_access_enabled = "true"
  on_demand_bursting_enabled    = "false"
  storage_account_type          = "Standard_LRS"
  # trusted_launch_enabled        = "false"
}

## Ubuntu Virtual Machine
resource "azurerm_linux_virtual_machine" "tpi_k3s_azure_edge" {
  admin_ssh_key {
    username   = "danmanners"
    public_key = var.ssh_auth.ssh_rsa
  }

  admin_username                  = "danmanners"
  allow_extension_operations      = "true"
  computer_name                   = "tpi-k3s-azure-edge"
  disable_password_authentication = "true"
  encryption_at_host_enabled      = "false"
  # extensions_time_budget          = "PT1H30M"
  location                        = var.azure.location
  max_bid_price                   = "-1"
  name                            = "tpi-k3s-azure-edge"
  network_interface_ids           = [
    azurerm_network_interface.k3s_vm_nic.id
  ]

  os_disk {
    caching                   = "ReadWrite"
    disk_size_gb              = "32"
    name                      = azurerm_managed_disk.tpi-k3s-azure-edge_disk1_70a4f4157fd847dc91d8c5a76b3840fe.name
    # name                      = "tpi-k3s-azure-edge_disk1_70a4f4157fd847dc91d8c5a76b3840fe"
    storage_account_type      = "Standard_LRS"
    write_accelerator_enabled = "false"
  }

  patch_mode            = "ImageDefault"
  # platform_fault_domain = "-1"
  priority              = "Regular"
  provision_vm_agent    = "true"
  resource_group_name   = "HOMELAB-LEARNING"
  secure_boot_enabled   = "false"
  size                  = "Standard_B2s"

  source_image_reference {
    offer     = "0001-com-ubuntu-server-focal"
    publisher = "canonical"
    sku       = "20_04-lts-gen2"
    version   = "latest"
  }

  vtpm_enabled = "false"
}
