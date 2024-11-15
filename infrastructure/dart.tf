resource "azurerm_storage_account" "dart_terraform_storage" {
  #checkov:skip=CKV2_AZURE_1: Customer Managed Keys not implemented
  #checkov:skip=CKV2_AZURE_18: Customer Managed Keys not implemented
  #checkov:skip=CKV_AZURE_33: logging not required
  #checkov:skip=CKV_AZURE_35: terraform requires access
  name                             = "pinsstterraformdartuks"
  resource_group_name              = local.shared_terraform_resource_group
  location                         = azurerm_resource_group.tooling.location
  account_tier                     = "Standard"
  account_replication_type         = "LRS"
  min_tls_version                  = "TLS1_2"
  cross_tenant_replication_enabled = true

  tags = local.tags
}

resource "azurerm_storage_container" "dart_terraform_storage_containers" {
  for_each = toset(["dev", "test", "training", "prod"])

  #checkov:skip=CKV2_AZURE_21: logging not required
  name                  = "dart-terraform-state-${each.key}"
  storage_account_name  = azurerm_storage_account.dart_terraform_storage.name
  container_access_type = "private"
}
