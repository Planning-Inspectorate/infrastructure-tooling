data "azurerm_client_config" "current" {}

data "azurerm_subscription" "current" {}

data "azurerm_image" "azure_agents" {
  # terraform 1.9.6
  name_regex          = "azure-agents-20241114133024"
  sort_descending     = true
  resource_group_name = azurerm_resource_group.tooling.name
}
