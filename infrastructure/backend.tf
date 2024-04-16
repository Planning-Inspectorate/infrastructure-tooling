terraform {
  backend "azurerm" {
    resource_group_name  = "pins-rg-shared-terraform-uks" # can't use the local var for this
    storage_account_name = "pinsstsharedtfstateuks"
    container_name       = "terraformstate"
    key                  = "tooling.tfstate"
  }
}
