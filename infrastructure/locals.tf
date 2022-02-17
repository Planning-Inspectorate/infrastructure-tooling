locals {
  resource_suffix = "shared-${var.environment}-${module.azure_region_primary.location_short}"

  tags = {
    CostCentre  = "90117"
    CreatedBy   = "terraform"
    Region      = var.primary_region
    ServiceName = "shared"
  }
}
