resource "azurerm_role_definition" "custom_storage_blob_data_read_write_delete" {
  name  = "Storage Blob Data - Read Write Delete (custom)"
  scope = data.azurerm_subscription.current.id

  permissions {
    actions = [
      "Microsoft.Storage/storageAccounts/blobServices/containers/blobs/delete",
      "Microsoft.Storage/storageAccounts/blobServices/containers/blobs/read",
      "Microsoft.Storage/storageAccounts/blobServices/containers/blobs/write",
      "Microsoft.Storage/storageAccounts/blobServices/containers/blobs/add/action"
    ]
    not_actions = []
  }
}
