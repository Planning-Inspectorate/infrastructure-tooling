data "azurerm_client_config" "current" {}

data "azurerm_subscription" "current" {}

# Owned by the infrastructure/ stack
data "azurerm_resource_group" "tooling" {
  name = "pins-rg-${local.resource_suffix}"
}

data "azurerm_virtual_network" "tooling" {
  name                = "pins-vnet-${local.resource_suffix}"
  resource_group_name = data.azurerm_resource_group.tooling.name
}

data "azurerm_image" "azure_agents" {
  name                = "azure-agents-gen2-2026-09-10-0842"
  resource_group_name = data.azurerm_resource_group.tooling.name
}

data "azurerm_image" "azure_agents_test" {
  name                = "azure-agents-gen2-2026-09-10-0842"
  resource_group_name = data.azurerm_resource_group.tooling.name
}

data "azurerm_key_vault" "tooling_key_vault" {
  name                = replace("pinskv${local.resource_suffix}", "-", "")
  resource_group_name = data.azurerm_resource_group.tooling.name
}
