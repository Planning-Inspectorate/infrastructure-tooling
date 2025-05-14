module "azure_region_primary" {
  source  = "claranet/regions/azurerm"
  version = "8.0.2"

  azure_region = var.primary_region
}

module "azure_region_secondary" {
  source  = "claranet/regions/azurerm"
  version = "8.0.2"

  azure_region = var.secondary_region
}
