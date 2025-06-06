resource "azurerm_key_vault" "tooling_key_vault" {
  #checkov:skip=CKV_AZURE_42: Soft delete protection enabled by default in latest Azure provider
  #checkov:skip=CKV_AZURE_109: TODO: Network ACL, currently not implemented as it blocks pipeline
  #checkov:skip=CKV_AZURE_189: "Ensure that Azure Key Vault disables public network access"
  #checkov:skip=CKV2_AZURE_32: "Ensure private endpoint is configured to key vault"
  name                        = replace("pinskv${local.resource_suffix}", "-", "")
  location                    = azurerm_resource_group.tooling.location
  resource_group_name         = azurerm_resource_group.tooling.name
  enabled_for_disk_encryption = true
  purge_protection_enabled    = true
  soft_delete_retention_days  = 7
  tenant_id                   = data.azurerm_client_config.current.tenant_id

  sku_name = "standard"

  tags = local.tags
}

# managed manually in Portal, to avoid a race condition where the pipeline needs to read secrets as well as create this
# resource "azurerm_key_vault_access_policy" "terraform" {
#   key_vault_id = azurerm_key_vault.tooling_key_vault.id
#   object_id    = data.azurerm_client_config.current.object_id
#   tenant_id    = data.azurerm_client_config.current.tenant_id

#   certificate_permissions = ["Create", "Delete", "Get", "Import", "List"]
#   key_permissions         = ["Create", "Delete", "Get", "List"]
#   secret_permissions      = ["Delete", "Get", "List", "Set"]
#   storage_permissions     = ["Delete", "Get", "List", "Set"]
# }

resource "azurerm_key_vault_access_policy" "admins" {
  key_vault_id = azurerm_key_vault.tooling_key_vault.id
  object_id    = "6e0b1ad0-76db-4871-b8d8-9d7b539527ff" # "PINS ODT Key Vault Admins"
  tenant_id    = data.azurerm_client_config.current.tenant_id

  certificate_permissions = ["Create", "Get", "Import", "List"]
  key_permissions         = ["Create", "Get", "List"]
  secret_permissions      = ["Get", "List", "Set"]
  storage_permissions     = ["Get", "List", "Set"]
}

resource "random_password" "agents_admin_password" {
  length  = 20
  special = true
}

resource "azurerm_key_vault_secret" "agents_admin_password" {
  #checkov:skip=CKV_AZURE_41: TODO: Secret rotation
  content_type = "text/plain"
  key_vault_id = azurerm_key_vault.tooling_key_vault.id
  name         = "agents-admin-password"
  value        = random_password.agents_admin_password.result

  tags = local.tags

  lifecycle {
    ignore_changes = [
      value
    ]
  }
}
