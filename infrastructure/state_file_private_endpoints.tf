locals {
  state_file_storage_accounts = {
    "pinsstsharedtfstateuks"   = azurerm_storage_account.shared_terraform_storage.id
    # "pinssttfstateuksappealbo" = azurerm_storage_account.appeals_back_office_terraform_storage.id
    # "pinssttfstateada"         = azurerm_storage_account.appeals_decision_assistant_terraform_storage.id
    # "pinssttfstateuksappealfo" = azurerm_storage_account.appeals_front_office_terraform_storage.id
    # "pinssttfstateappealsmigr" = azurerm_storage_account.appeals_migration_terraform_storage.id
    # "pinssttfstateuksappbo"    = azurerm_storage_account.applications_back_office_terraform_storage.id
    # "pinssttfstateuksappserfo" = azurerm_storage_account.applications_front_office_terraform_storage.id
    # "pinssttfstatecwp"         = azurerm_storage_account.casework_portal_terraform_storage.id
    # "pinssttfstateukscrowndev" = azurerm_storage_account.crown_development_terraform_storage.id
    # "pinssttfstateuksdcop"     = azurerm_storage_account.dcop_terraform_storage.id
    # "pinsstterraformdartuks"   = azurerm_storage_account.dart_terraform_storage.id
    # "pinssttfstatelocalplans"  = azurerm_storage_account.local_plans_terraform_storage.id
    # "pinssttfstateukspeas"     = azurerm_storage_account.peas_terraform_storage.id
    # "pinssttfstateukprotinfra" = azurerm_storage_account.prototypes_common_infrastructure_terraform_storage.id
    # "pinssttfstateredaction"   = azurerm_storage_account.redaction_terraform_storage.id
    # "pinssttfstateuksscheduli" = azurerm_storage_account.scheduling_terraform_storage.id
    "pinssttfstateukstemplate" = azurerm_storage_account.template_app_terraform_storage.id
  }
}

resource "azurerm_private_endpoint" "state_file" {
  for_each = local.state_file_storage_accounts

  name                = "pins-pe-${each.key}-${local.resource_suffix}"
  location            = azurerm_resource_group.tooling.location
  resource_group_name = azurerm_resource_group.tooling.name
  subnet_id           = azurerm_subnet.azure_agents.id

  private_dns_zone_group {
    name                 = "state-file-private-dns-zone-group-${each.key}"
    private_dns_zone_ids = [azurerm_private_dns_zone.storage["blob"].id]
  }

  private_service_connection {
    name                           = "privateendpointconnection-${each.key}"
    private_connection_resource_id = each.value
    subresource_names              = ["blob"]
    is_manual_connection           = false
  }

  depends_on = [
    azurerm_private_dns_zone_virtual_network_link.storage
  ]

  tags = local.tags
}
