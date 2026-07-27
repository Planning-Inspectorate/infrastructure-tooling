resource "azurerm_private_endpoint" "state_file" {
  name                = "pins-pe-state-file-${local.resource_suffix}"
  location            = azurerm_resource_group.tooling.location
  resource_group_name = azurerm_resource_group.tooling.name
  subnet_id           = azurerm_subnet.azure_agents.id

  private_dns_zone_group {
    name                 = "state-file-private-dns-zone-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.storage["blob"].id]
  }

  private_service_connection {
    name                           = "privateendpointconnection"
    private_connection_resource_id = azurerm_storage_account.template_app_terraform_storage.id
    subresource_names              = ["blob"]
    is_manual_connection           = false
  }

  depends_on = [
    azurerm_private_dns_zone_virtual_network_link.storage,
    azurerm_storage_account.template_app_terraform_storage
  ]

  tags = local.tags
}
