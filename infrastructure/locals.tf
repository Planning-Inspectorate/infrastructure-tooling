locals {
  agent_pools = {
    main = {
      name     = "pins-vmss-${local.resource_suffix}"
      nic_name = "pins-vnet-azure-agents-nic-${local.resource_suffix}"
    }
    test = {
      name     = "pins-vmss-test-${local.resource_suffix}"
      nic_name = "pins-vnet-azure-agents-nic-test-${local.resource_suffix}"
    }
  }

  resource_suffix = "shared-${var.environment}-${module.azure_region_primary.location_short}"

  tags = {
    CostCentre  = "90117"
    CreatedBy   = "terraform"
    Region      = var.primary_region
    ServiceName = "shared"
  }
}
