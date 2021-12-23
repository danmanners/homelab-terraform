terraform {
  required_providers {
    # Azure Provider
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.90.0"
    }
  }

  # Google Cloud Bucket Storage for State File
  backend "gcs" {
    bucket  = "dm-homelab-tfstate"
    prefix  = "do/state"
  }
}
