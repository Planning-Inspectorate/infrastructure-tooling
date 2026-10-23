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

data "azurerm_subnet" "azure_agents" {
  provider             = azurerm.shared_tooling
  name                 = "pins-snet-azure-agents-shared-tooling-uks"
  virtual_network_name = "pins-vnet-shared-tooling-uks"
  resource_group_name  = "pins-rg-shared-tooling-uks"
}
