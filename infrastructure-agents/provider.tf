terraform {
  backend "azurerm" {
    resource_group_name  = "pins-rg-shared-terraform-uks"
    storage_account_name = "pinsstsharedtfstateuks"
    container_name       = "terraformstate"
    key                  = "tooling.tfstate"
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "> 4"
    }
  }
  required_version = ">= 1.11.0, < 1.17.0"
}

provider "azurerm" {
  features {}
}
