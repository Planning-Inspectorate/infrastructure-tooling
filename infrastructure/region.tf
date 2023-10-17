module "azure_region_primary" {
  source  = "claranet/regions/azurerm"
  version = "4.2.1"

  azure_region = var.primary_region
}

module "azure_region_secondary" {
  source  = "claranet/regions/azurerm"
  version = "4.2.1"

  azure_region = var.secondary_region
}
