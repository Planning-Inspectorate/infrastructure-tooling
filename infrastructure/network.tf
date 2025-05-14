resource "azurerm_virtual_network" "tooling" {
  name                = "pins-vnet-${local.resource_suffix}"
  resource_group_name = azurerm_resource_group.tooling.name
  location            = azurerm_resource_group.tooling.location
  address_space       = ["10.10.0.0/16"] # 65536 IPs

  tags = local.tags
}

resource "azurerm_subnet" "azure_agents" {
  name                              = "pins-snet-azure-agents-${local.resource_suffix}"
  resource_group_name               = azurerm_resource_group.tooling.name
  virtual_network_name              = azurerm_virtual_network.tooling.name
  address_prefixes                  = ["10.10.0.0/24"] # 256 IPs
  private_endpoint_network_policies = "Enabled"
}

resource "azurerm_subnet" "GatewaySubnet" {
  name                              = "GatewaySubnet"
  resource_group_name               = azurerm_resource_group.tooling.name
  virtual_network_name              = azurerm_virtual_network.tooling.name
  address_prefixes                  = ["10.10.1.0/24"] # 256 IPs
  private_endpoint_network_policies = "Enabled"
}

resource "azurerm_subnet" "vpn_resolver" {
  name                              = "pins-snet-vpn-resolver-${local.resource_suffix}"
  resource_group_name               = azurerm_resource_group.tooling.name
  virtual_network_name              = azurerm_virtual_network.tooling.name
  address_prefixes                  = ["10.10.2.0/24"] # 256 IPs
  private_endpoint_network_policies = "Enabled"

  delegation {
    name = "Microsoft.Network.dnsResolvers"
    service_delegation {
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
      name    = "Microsoft.Network/dnsResolvers"
    }
  }
}

resource "azurerm_subnet" "vpn_dns_resolver" {
  name                              = "pins-snet-vpn-inbounddns-${local.resource_suffix}"
  resource_group_name               = azurerm_resource_group.tooling.name
  virtual_network_name              = azurerm_virtual_network.tooling.name
  address_prefixes                  = ["10.10.3.0/24"] # 256 IPs
  private_endpoint_network_policies = "Enabled"

  delegation {
    name = "Microsoft.Network.dnsResolvers"
    service_delegation {
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
      name    = "Microsoft.Network/dnsResolvers"
    }
  }
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
  private_dns_zone_name = azurerm_private_dns_zone.azure_synapse.name
  resource_group_name   = azurerm_resource_group.tooling.name
  virtual_network_id    = azurerm_virtual_network.tooling.id
}

resource "azurerm_private_dns_zone" "azure_synapse_dev" {
  name                = "privatelink.dev.azuresynapse.net"
  resource_group_name = azurerm_resource_group.tooling.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "azure_synapse_dev" {
  name                  = "pins-vnetlink-az-synapse-dev-${local.resource_suffix}"
  private_dns_zone_name = azurerm_private_dns_zone.azure_synapse_dev.name
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

locals {
  storage_zones = ["blob", "dfs", "file", "queue", "table", "web"]
}

resource "azurerm_private_dns_zone" "storage" {
  for_each            = toset(local.storage_zones)
  name                = "privatelink.${each.key}.core.windows.net"
  resource_group_name = azurerm_resource_group.tooling.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "storage" {
  for_each = toset(local.storage_zones)

  name                  = "pins-vnetlink-${each.key}-${local.resource_suffix}"
  private_dns_zone_name = azurerm_private_dns_zone.storage[each.key].name
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

resource "azurerm_private_dns_zone" "vaultcore" {
  name                = "privatelink.vaultcore.azure.net"
  resource_group_name = azurerm_resource_group.tooling.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "vaultcore" {
  name                  = "pins-vnetlink-vaultcore-${local.resource_suffix}"
  private_dns_zone_name = azurerm_private_dns_zone.vaultcore.name
  resource_group_name   = azurerm_resource_group.tooling.name
  virtual_network_id    = azurerm_virtual_network.tooling.id
}

locals {
  virtual_network_links = merge(
    {
      "app_config"             = azurerm_private_dns_zone_virtual_network_link.app_config,
      "azure_synapse"          = azurerm_private_dns_zone_virtual_network_link.azure_synapse,
      "azure_synapse_dev"      = azurerm_private_dns_zone_virtual_network_link.azure_synapse_dev,
      "app_service"            = azurerm_private_dns_zone_virtual_network_link.app_service,
      "cosmosdb"               = azurerm_private_dns_zone_virtual_network_link.cosmosdb,
      "back_office_sql_server" = azurerm_private_dns_zone_virtual_network_link.back_office_sql_server,
      "redis"                  = azurerm_private_dns_zone_virtual_network_link.redis,
      "service_bus"            = azurerm_private_dns_zone_virtual_network_link.service_bus,
      "synapse"                = azurerm_private_dns_zone_virtual_network_link.synapse,
      "vaultcore"              = azurerm_private_dns_zone_virtual_network_link.vaultcore
    },
    {
      for k, v in azurerm_private_dns_zone_virtual_network_link.storage : k => v
    }
  )
}

# always fallback to internet - not available via azurerm currently
# https://github.com/hashicorp/terraform-provider-azurerm/issues/29196
resource "azapi_update_resource" "main" {
  for_each = local.virtual_network_links

  type        = "Microsoft.Network/privateDnsZones/virtualNetworkLinks@2024-06-01"
  resource_id = each.value.id
  body = {
    properties = {
      resolutionPolicy = "NxDomainRedirect",
    }
  }
  depends_on = [
    azurerm_private_dns_zone_virtual_network_link.app_config,
    azurerm_private_dns_zone_virtual_network_link.azure_synapse,
    azurerm_private_dns_zone_virtual_network_link.azure_synapse_dev,
    azurerm_private_dns_zone_virtual_network_link.app_service,
    azurerm_private_dns_zone_virtual_network_link.cosmosdb,
    azurerm_private_dns_zone_virtual_network_link.back_office_sql_server,
    azurerm_private_dns_zone_virtual_network_link.redis,
    azurerm_private_dns_zone_virtual_network_link.service_bus,
    azurerm_private_dns_zone_virtual_network_link.storage,
    azurerm_private_dns_zone_virtual_network_link.synapse,
    azurerm_private_dns_zone_virtual_network_link.vaultcore
  ]
}