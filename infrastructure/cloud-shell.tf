resource "azurerm_storage_account" "cloud_shell" {
  #TODO: Customer Managed Keys
  #checkov:skip=CKV_AZURE_3: Secure transfer not required
  #checkov:skip=CKV_AZURE_33: Logging not required for Cloud Shell
  #checkov:skip=CKV_AZURE_35: Cloud Shell requires access
  #checkov:skip=CKV2_AZURE_1: Customer Managed Keys not implemented yet
  #checkov:skip=CKV2_AZURE_18: Customer Managed Keys not implemented yet
  name                     = "pinsstsharedshelluks"
  resource_group_name      = azurerm_resource_group.tooling.name
  location                 = azurerm_resource_group.tooling.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  min_tls_version          = "TLS1_2"

  tags = merge(local.tags, {
    ms-resource-usage = "azure-cloud-shell"
  })
}
