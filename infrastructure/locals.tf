locals {
  agent_pools = {
    main = {
      name     = "pins-vmss-${local.resource_suffix}"
      nic_name = "pins-vnet-azure-agents-nic-${local.resource_suffix}"
      sku      = "Standard_DS2_v2"
    }
    test = {
      name     = "pins-vmss-test-${local.resource_suffix}"
      nic_name = "pins-vnet-azure-agents-nic-test-${local.resource_suffix}"
      sku      = "Standard_DS3_v2"
    }
  }

  agent_pools_test = {
    spec_1 = {
      name     = "pins-vmss-spec-1-${local.resource_suffix}"
      nic_name = "pins-vnet-azure-agents-nic-spec-1-${local.resource_suffix}"
      sku      = "Standard_D4plds_v5"
    }
    spec_2 = {
      name     = "pins-vmss-spec-2-${local.resource_suffix}"
      nic_name = "pins-vnet-azure-agents-nic-spec-2-${local.resource_suffix}"
      sku      = "Standard_D4pds_v5"
    }
    spec_3 = {
      name     = "pins-vmss-spec-3-${local.resource_suffix}"
      nic_name = "pins-vnet-azure-agents-nic-spec-3-${local.resource_suffix}"
      sku      = "Standard_D8plds_v5"
    }
  }

  shared_terraform_resource_group = "pins-rg-shared-terraform-uks"

  resource_suffix = "shared-${var.environment}-${module.azure_region_primary.location_short}"

  tags = {
    CostCentre  = "90117"
    CreatedBy   = "terraform"
    Region      = var.primary_region
    ServiceName = "shared"
  }
}
