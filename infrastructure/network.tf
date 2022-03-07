resource "azurerm_virtual_network" "tooling" {
  name                = "pins-vnet-${local.resource_suffix}"
  resource_group_name = azurerm_resource_group.tooling.name
  location            = azurerm_resource_group.tooling.location
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "azure_agents" {
  name                 = "pins-snet-azure-agents-${local.resource_suffix}"
  resource_group_name  = azurerm_resource_group.tooling.name
  virtual_network_name = azurerm_virtual_network.tooling.name
  address_prefixes     = ["10.0.0.0/24"]
}

resource "azurerm_virtual_network_peering" "environments_peering" {
  for_each = var.environment_vnets

  name                      = "pins-peer-${each.key}-${local.resource_suffix}"
  remote_virtual_network_id = data.azurerm_virtual_network.environments[each.key].id
  resource_group_name       = azurerm_resource_group.tooling.name
  virtual_network_name      = azurerm_virtual_network.tooling.name
}
