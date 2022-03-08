data "azurerm_client_config" "current" {}

data "azurerm_image" "azure_agents" {
  name                = "azure-agents"
  resource_group_name = azurerm_resource_group.tooling.name
}

data "azurerm_virtual_network" "dev" {
  count = can(var.environment_vnets["dev"]) ? 1 : 0

  name                = var.environment_vnets["dev"]["name"]
  resource_group_name = var.environment_vnets["dev"]["resource_group"]

  provider = azurerm.dev
}

data "azurerm_virtual_network" "test" {
  count = can(var.environment_vnets["test"]) ? 1 : 0

  name                = var.environment_vnets["test"]["name"]
  resource_group_name = var.environment_vnets["test"]["resource_group"]

  provider = azurerm.test
}

data "azurerm_virtual_network" "prod" {
  count = can(var.environment_vnets["prod"]) ? 1 : 0

  name                = var.environment_vnets["prod"]["name"]
  resource_group_name = var.environment_vnets["prod"]["resource_group"]

  provider = azurerm.prod
}
