resource "azurerm_container_registry" "acr" {
  #checkov:skip=CKV_AZURE_139: Access over internet required so Azure DevOps can push/pull images
  name                = "pinscr${replace(local.resource_suffix, "-", "")}"
  resource_group_name = azurerm_resource_group.tooling.name
  location            = azurerm_resource_group.tooling.location
  sku                 = "Premium"

  georeplications {
    location = module.azure_region_secondary.location
    tags     = merge(local.tags, { Region = var.secondary_region })
  }

  tags = local.tags
}
