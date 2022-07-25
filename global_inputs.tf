variable "cloud_auth" {
  description = "Multiple values for cloud authentication."
}

variable "aws" {
  description = "All AWS specific resource values should be loaded in this top-level map."
}

variable "azure" {
  description = "All Azure specific resources values should be loaded in this top-level map."
}

# variable "google" {
#   description = "All Azure specific resources values should be loaded in this top-level map."
# }
