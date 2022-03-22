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

resource "azurerm_private_dns_zone" "app_service" {
  name                = "privatelink.azurewebsites.net"
  resource_group_name = azurerm_resource_group.tooling.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "app_service" {
  name                  = "pins-vnetlink-app-service-${local.resource_suffix}"
  private_dns_zone_name = azurerm_private_dns_zone.app_service.name
  resource_group_name   = azurerm_resource_group.tooling.name
  virtual_network_id    = azurerm_virtual_network.tooling.id
}

resource "azurerm_private_dns_zone" "cosmosdb" {
  name                = "privatelink.mongo.cosmos.azure.com"
  resource_group_name = azurerm_resource_group.tooling.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "cosmosdb" {
  name                  = "pins-vnetlink-cosmosdb-${local.resource_suffix}"
  private_dns_zone_name = azurerm_private_dns_zone.cosmosdb.name
  resource_group_name   = azurerm_resource_group.tooling.name
  virtual_network_id    = azurerm_virtual_network.tooling.id
}
