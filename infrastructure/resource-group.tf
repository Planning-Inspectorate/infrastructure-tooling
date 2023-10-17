resource "azurerm_resource_group" "tooling" {
  name     = "pins-rg-${local.resource_suffix}"
  location = module.azure_region_primary.location
  tags     = local.tags
}
