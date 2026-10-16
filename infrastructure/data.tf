data "azurerm_client_config" "current" {}

data "azurerm_subscription" "current" {}

data "azurerm_subscription" "prod" {
  provider = azurerm.prod
}

data "azurerm_subscription" "odw_data_prod" {
  provider = azurerm.odw_data_prod
}

data "azurerm_resource_group" "common_prod" {
  provider = azurerm.prod
  name     = "pins-rg-common-prod"
}

data "azurerm_resource_group" "odw_monitoring" {
  provider = azurerm.odw_data_prod
  name     = "pins-rg-monitoring-odw-prod-uks"
}
