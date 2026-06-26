data "azurerm_client_config" "current" {}

data "azurerm_subscription" "current" {}

data "azurerm_image" "azure_agents" {
  name                = "azure-agents-gen2-2026-06-26-0835"
  resource_group_name = azurerm_resource_group.tooling.name
}

data "azurerm_image" "azure_agents_test" {
  name                = "azure-agents-gen2-2026-06-26-0835"
  resource_group_name = azurerm_resource_group.tooling.name
}
