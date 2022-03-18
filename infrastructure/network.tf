resource "azurerm_virtual_network" "tooling" {
  name                = "pins-vnet-${local.resource_suffix}"
  resource_group_name = azurerm_resource_group.tooling.name
  location            = azurerm_resource_group.tooling.location
  address_space       = ["10.10.0.0/24"]
}

resource "azurerm_subnet" "azure_agents" {
  name                 = "pins-snet-azure-agents-${local.resource_suffix}"
  resource_group_name  = azurerm_resource_group.tooling.name
  virtual_network_name = azurerm_virtual_network.tooling.name
  address_prefixes     = ["10.10.0.0/24"]
}

resource "azurerm_virtual_network_peering" "dev_environment_peering" {
  count = can(var.environment_vnets["dev"]) ? 1 : 0

  name                      = "pins-peer-dev-${local.resource_suffix}"
  remote_virtual_network_id = data.azurerm_virtual_network.dev[count.index].id
  resource_group_name       = azurerm_resource_group.tooling.name
  virtual_network_name      = azurerm_virtual_network.tooling.name
}

resource "azurerm_virtual_network_peering" "test_environment_peering" {
  count = can(var.environment_vnets["test"]) ? 1 : 0

  name                      = "pins-peer-test-${local.resource_suffix}"
  remote_virtual_network_id = data.azurerm_virtual_network.test[count.index].id
  resource_group_name       = azurerm_resource_group.tooling.name
  virtual_network_name      = azurerm_virtual_network.tooling.name
}

resource "azurerm_virtual_network_peering" "prod_environment_peering" {
  count = can(var.environment_vnets["prod"]) ? 1 : 0

  name                      = "pins-peer-prod-${local.resource_suffix}"
  remote_virtual_network_id = data.azurerm_virtual_network.prod[count.index].id
  resource_group_name       = azurerm_resource_group.tooling.name
  virtual_network_name      = azurerm_virtual_network.tooling.name
}

resource "azurerm_private_dns_zone" "app_service" {
  name                = "privatelink.azurewebsites.net"
  resource_group_name = azurerm_resource_group.tooling.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "app_service" {
  name                  = "pins-vnetlink-${local.resource_suffix}"
  resource_group_name   = azurerm_resource_group.tooling.name
  private_dns_zone_name = azurerm_private_dns_zone.app_service.name
  virtual_network_id    = azurerm_virtual_network.tooling.id
}
