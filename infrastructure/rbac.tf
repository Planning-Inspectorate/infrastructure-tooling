resource "azurerm_role_definition" "custom_storage_blob_data_read_write_delete" {
  name  = "Storage Blob Data - Read Write Delete (custom)"
  scope = data.azurerm_subscription.current.id

  assignable_scopes = [
    data.azurerm_subscription.current.id,
    "/subscriptions/962e477c-0f3b-4372-97fc-a198a58e259e", // odt dev
    "/subscriptions/76cf28c6-6fda-42f1-bcd9-6d7dbed704ef", // odt test
    "/subscriptions/dbfbfbbf-eb6f-457b-9c0c-fe3a071975bc", // odt training
    "/subscriptions/d1d6c393-2fe3-40af-ac27-f5b6bad36735"  // odt prod
  ]

  permissions {
    actions     = []
    not_actions = []
    data_actions = [
      "Microsoft.Storage/storageAccounts/blobServices/containers/blobs/delete",
      "Microsoft.Storage/storageAccounts/blobServices/containers/blobs/read",
      "Microsoft.Storage/storageAccounts/blobServices/containers/blobs/write",
      "Microsoft.Storage/storageAccounts/blobServices/containers/blobs/add/action"
    ]
  }
}
