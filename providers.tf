provider "aws" {
  // Ensure that you've set up your ~/.aws/credentials.conf file.
  // Set the region and profile name here.
  region = var.cloud_auth.aws_region
  profile = var.cloud_auth.aws_profile
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}
