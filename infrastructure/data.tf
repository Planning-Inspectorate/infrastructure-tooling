data "azurerm_client_config" "current" {}

data "azurerm_subscription" "current" {}

data "azurerm_image" "azure_agents" {
  name_regex          = "azure-agents"
  sort_descending     = true
  resource_group_name = azurerm_resource_group.tooling.name
}
