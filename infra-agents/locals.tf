locals {
  agent_pools = {
    main = {
      name     = "pins-vmss-${local.resource_suffix}"
      nic_name = "pins-vnet-azure-agents-nic-${local.resource_suffix}"
      sku      = "Standard_D4lds_v5"
      image_id = data.azurerm_image.azure_agents.id
    }
    test = {
      name     = "pins-vmss-test-${local.resource_suffix}"
      nic_name = "pins-vnet-azure-agents-nic-test-${local.resource_suffix}"
      sku      = "Standard_D4lds_v5"
      image_id = data.azurerm_image.azure_agents_test.id
    }
  }
  # This should be OK removing the module referencing and instead hard code. 
  # The suffix we keep as mulitple places reference it, we could hard code those too.
  resource_suffix = "shared-uks"

  tags = {
    CostCentre  = "90117"
    CreatedBy   = "terraform"
    Region      = "uks"# var.primary_region # Only ever in one region, hard code it as "uks"?
    ServiceName = "shared"
  }
}
