resource "azurerm_storage_account" "cloud_shell" {
  #checkov:skip=CKV2_AZURE_38: "Ensure soft-delete is enabled on Azure storage account"
  #checkov:skip=CKV2_AZURE_41: "Ensure storage account is configured with SAS expiration policy"
  #TODO: Customer Managed Keys
  #checkov:skip=CKV_AZURE_3: Secure transfer not required
  #checkov:skip=CKV_AZURE_33: Logging not required for Cloud Shell
  #checkov:skip=CKV_AZURE_35: Cloud Shell requires access
  #checkov:skip=CKV2_AZURE_1: Customer Managed Keys not implemented yet
  #checkov:skip=CKV2_AZURE_18: Customer Managed Keys not implemented yet
  #checkov:skip=CKV_AZURE_59: "Ensure that Storage accounts disallow public access"
  #checkov:skip=CKV_AZURE_206: "Ensure that Storage Accounts use replication"
  #checkov:skip=CKV_AZURE_190: "Ensure that Storage blobs restrict public access"
  #checkov:skip=CKV2_AZURE_40: "Ensure storage account is not configured with Shared Key authorization"
  #checkov:skip=CKV2_AZURE_47: "Ensure storage account is configured without blob anonymous access"
  #checkov:skip=CKV2_AZURE_33: "Ensure storage account is configured with private endpoint"
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
