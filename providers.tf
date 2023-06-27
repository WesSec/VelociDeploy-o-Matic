terraform {

  required_version = ">=0.12"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      # version = "~> 2.99"
    }
  }
}

provider "azurerm" {
  features {}
  skip_provider_registration = true
}