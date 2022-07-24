variable "azurerm_resource_group" {
  description = "Defines the Azure Resource Group Name"
}

variable "azure_location" {
  description = "Defines the location to deploy the network"
}

variable "network_name" {
  description = "Sets the name of the network"
}

variable "address_space" {
  description = "Map object containing public and private subnet definitions"
  type = list(string)
}

variable "subnets" {
  description = "Map object containing public and private subnet definitions"
}

variable "tags" {
  description = "Any tags that should be globally assigned"
}

variable "extra_tags" {
  description = "Additional tags on a per-module basis; optional"
  default = {}
}
