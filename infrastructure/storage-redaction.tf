resource "azurerm_storage_account" "redaction_terraform_storage" {
  #checkov:skip=CKV2_AZURE_38: Ensure soft-delete is enabled on Azure storage account
  #checkov:skip=CKV2_AZURE_41: Ensure storage account is configured with SAS expiration policy
  #checkov:skip=CKV2_AZURE_1:  Customer Managed Keys not implemented
  #checkov:skip=CKV2_AZURE_18: Customer Managed Keys not implemented
  #checkov:skip=CKV_AZURE_33:  Logging not required
  #checkov:skip=CKV_AZURE_35:  Terraform requires access
  #checkov:skip=CKV_AZURE_59:  Ensure that Storage accounts disallow public access
  #checkov:skip=CKV_AZURE_206: Ensure that Storage Accounts use replication
  #checkov:skip=CKV_AZURE_190: Ensure that Storage blobs restrict public access
  #checkov:skip=CKV2_AZURE_40: Ensure storage account is not configured with Shared Key authorization
  #checkov:skip=CKV2_AZURE_47: Ensure storage account is configured without blob anonymous access
  #checkov:skip=CKV2_AZURE_33: Ensure storage account is configured with private endpoint

  name                             = "pinssttfstateredaction"
  resource_group_name              = local.shared_terraform_resource_group
  location                         = azurerm_resource_group.tooling.location
  account_tier                     = "Standard"
  account_replication_type         = "LRS"
  min_tls_version                  = "TLS1_2"
  cross_tenant_replication_enabled = true

  tags = local.tags
}

resource "azurerm_storage_container" "redaction_terraform_storage_containers" {
  for_each = toset(["dev", "test", "prod", "training"])

  #checkov:skip=CKV2_AZURE_21: logging not required

  name                  = "terraform-state-redaction-${each.key}"
  storage_account_id    = azurerm_storage_account.redaction_terraform_storage.id
  container_access_type = "private"
}
