terraform {
  backend "azurerm" {
    resource_group_name  = local.shared_terraform_resource_group
    storage_account_name = "pinsstsharedtfstateuks"
    container_name       = "terraformstate"
    key                  = "tooling.tfstate"
  }
}
