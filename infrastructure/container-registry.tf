resource "azurerm_container_registry" "acr" {
  #checkov:skip=CKV_AZURE_164: Ensures that ACR uses signed/trusted images
  #checkov:skip=CKV_AZURE_137: Admin account required so App services can pull containers when updated by pipeline
  #checkov:skip=CKV_AZURE_139: Access over internet required so Azure DevOps can push/pull images
  #checkov:skip=CKV_AZURE_237: "Ensure dedicated data endpoints are enabled."
  #checkov:skip=CKV_AZURE_166: "Ensure container image quarantine, scan, and mark images verified"
  #checkov:skip=CKV_AZURE_167: "Ensure a retention policy is set to cleanup untagged manifests."
  #checkov:skip=CKV_AZURE_233: "Ensure Azure Container Registry (ACR) is zone redundant"
  name                = "pinscr${replace(local.resource_suffix, "-", "")}"
  resource_group_name = azurerm_resource_group.tooling.name
  location            = azurerm_resource_group.tooling.location
  admin_enabled       = true
  sku                 = "Premium"

  georeplications {
    location = module.azure_region_secondary.location
    tags     = merge(local.tags, { Region = var.secondary_region })
  }

  tags = local.tags
}
