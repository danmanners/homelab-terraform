variable "azurerm_resource_group" {
  description = "Defines the Azure Resource Group Name"
}

variable "azure_location" {
  description = "Defines the location to deploy the network"
}

variable "security_group_name" {
  description = "Name for the security group"
}

variable "security_group_rules" {
  description = "List of Map objects containing the security group rules"
  type        = list(map(any))
}

variable "tags" {
  description = "Any tags that should be globally assigned"
}

variable "extra_tags" {
  description = "Additional tags on a per-module basis; optional"
  default     = {}
}
