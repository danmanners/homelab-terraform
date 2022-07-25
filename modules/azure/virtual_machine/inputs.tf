variable "azurerm_resource_group" {
  description = "Defines the Azure Resource Group Name"
}

variable "azure_location" {
  description = "Defines the location to deploy the network"
}

variable "vm_values" {
  description = "Defines the values for VMs to create"
  type        = list(map(any))
}

variable "network_name" {
  description = "Network name to perform subnet lookups from"
  type        = string
}

variable "talos_version" {
  description = "Version of the Talos disk image to deploy"
  type        = string
}

variable "tags" {
  description = "Any tags that should be globally assigned"
}

variable "extra_tags" {
  description = "Additional tags on a per-module basis; optional"
  default     = {}
}
