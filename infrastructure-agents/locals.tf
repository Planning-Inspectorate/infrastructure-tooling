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

  resource_suffix = "shared-tooling-uks"

  tags = {
    CostCentre  = "90117"
    CreatedBy   = "terraform"
    Region      = "uk-south"
    ServiceName = "shared"
  }
}
