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

resource "azurerm_private_dns_zone" "app_config" {
  name                = "privatelink.azconfig.io"
  resource_group_name = azurerm_resource_group.tooling.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "app_config" {
  name                  = "pins-vnetlink-app-config-${local.resource_suffix}"
  private_dns_zone_name = azurerm_private_dns_zone.app_config.name
  resource_group_name   = azurerm_resource_group.tooling.name
  virtual_network_id    = azurerm_virtual_network.tooling.id
}

resource "azurerm_private_dns_zone" "azure_synapse" {
  name                = "privatelink.azuresynapse.net"
  resource_group_name = azurerm_resource_group.tooling.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "azure_synapse" {
  name                  = "pins-vnetlink-az-synapse-${local.resource_suffix}"
  private_dns_zone_name = azurerm_private_dns_zone.app_config.name
  resource_group_name   = azurerm_resource_group.tooling.name
  virtual_network_id    = azurerm_virtual_network.tooling.id
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

resource "azurerm_private_dns_zone" "database" {
  name                = "privatelink.database.windows.net"
  resource_group_name = azurerm_resource_group.tooling.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "back_office_sql_server" {
  name                  = "pins-vnetlink-sql-server-${local.resource_suffix}"
  private_dns_zone_name = azurerm_private_dns_zone.database.name
  resource_group_name   = azurerm_resource_group.tooling.name
  virtual_network_id    = azurerm_virtual_network.tooling.id
}

resource "azurerm_private_dns_zone" "internal" {
  name                = "pins.internal"
  resource_group_name = azurerm_resource_group.tooling.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "internal" {
  name                  = "pins-vnetlink-internal-${local.resource_suffix}"
  private_dns_zone_name = azurerm_private_dns_zone.internal.name
  resource_group_name   = azurerm_resource_group.tooling.name
  virtual_network_id    = azurerm_virtual_network.tooling.id
}

resource "azurerm_private_dns_zone" "redis" {
  name                = "privatelink.redis.cache.windows.net"
  resource_group_name = azurerm_resource_group.tooling.name
}
resource "azurerm_private_dns_zone_virtual_network_link" "redis" {
  name                  = "pins-vnetlink-redis-${local.resource_suffix}"
  private_dns_zone_name = azurerm_private_dns_zone.redis.name
  resource_group_name   = azurerm_resource_group.tooling.name
  virtual_network_id    = azurerm_virtual_network.tooling.id
}

resource "azurerm_private_dns_zone" "service_bus" {
  name                = "privatelink.servicebus.windows.net"
  resource_group_name = azurerm_resource_group.tooling.name
}
resource "azurerm_private_dns_zone_virtual_network_link" "service_bus" {
  name                  = "pins-vnetlink-service-bus-${local.resource_suffix}"
  private_dns_zone_name = azurerm_private_dns_zone.service_bus.name
  resource_group_name   = azurerm_resource_group.tooling.name
  virtual_network_id    = azurerm_virtual_network.tooling.id
}

resource "azurerm_private_dns_zone" "synapse" {
  name                = "privatelink.sql.azuresynapse.net"
  resource_group_name = azurerm_resource_group.tooling.name
}
resource "azurerm_private_dns_zone_virtual_network_link" "synapse" {
  name                  = "pins-vnetlink-synapse-${local.resource_suffix}"
  private_dns_zone_name = azurerm_private_dns_zone.synapse.name
  resource_group_name   = azurerm_resource_group.tooling.name
  virtual_network_id    = azurerm_virtual_network.tooling.id
}