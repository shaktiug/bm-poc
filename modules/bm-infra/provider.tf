##
# Configure the Azure Provider
##

terraform {
  backend "azurerm" {
    resource_group_name  = "sample"
    storage_account_name = "testsa1919"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.0.0"
    }
  }
}

provider "azurerm" {
  features {}
}