resource "azurerm_container_registry" "acr" {
  #checkov:skip=CKV_AZURE_137: Admin account required so App services can pull containers when updated by pipeline
  #checkov:skip=CKV_AZURE_139: Access over internet required so Azure DevOps can push/pull images
  name                = "pinscr${replace(local.resource_suffix, "-", "")}"
  resource_group_name = azurerm_resource_group.tooling.name
  location            = azurerm_resource_group.tooling.location
  admin_enabled       = true
  sku                 = "Premium"

  georeplications {
    location = module.azure_region_secondary.location
    tags     = merge(local.tags, { Region = var.secondary_region })
  }

  lifecycle {
    ignore_changes = [
      DOCKER_REGISTRY_SERVER_PASSWORD,
      DOCKER_REGISTRY_SERVER_URL,
      DOCKER_REGISTRY_SERVER_USERNAME
    ]
  }

  tags = local.tags
}
