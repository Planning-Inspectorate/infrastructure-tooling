# shared TextAnalytics/Language service resource for all non-live services
resource "azurerm_cognitive_account" "text_analytics" {
  #checkov:skip=CKV2_AZURE_22: customer-managed keys not implemented yet
  name                          = "pins-lang-${local.resource_suffix}"
  location                      = azurerm_resource_group.tooling.location
  resource_group_name           = azurerm_resource_group.tooling.name
  kind                          = "TextAnalytics"
  public_network_access_enabled = false
  local_auth_enabled            = false

  sku_name = "F0"

  identity {
    type = "SystemAssigned"
  }

  tags = local.tags
}

resource "azurerm_private_endpoint" "private_endpoint" {
  name                = "pins-pe-lang-${local.resource_suffix}"
  location            = azurerm_resource_group.tooling.location
  resource_group_name = azurerm_resource_group.tooling.name
  subnet_id           = azurerm_subnet.language_service.id

  private_dns_zone_group {
    name                 = "azure-lang-private-dns-zone-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.cognitive.id]
  }

  private_service_connection {
    name                           = "privateendpointconnection"
    private_connection_resource_id = azurerm_cognitive_account.text_analytics.id
    subresource_names              = ["account"]
    is_manual_connection           = false
  }

  tags = local.tags
}