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

  shared_terraform_resource_group = "pins-rg-shared-terraform-uks"

  resource_suffix = "shared-${var.environment}-${module.azure_region_primary.location_short}"

  tags = {
    CostCentre  = "90117"
    CreatedBy   = "terraform"
    Region      = var.primary_region
    ServiceName = "shared"
  }

  # Subscriptions to monitor for Service Health alerts (matched by exact display name)
  monitored_subscription_names = toset([
    "pins-odt-apps-prod-sub",
    "pins-odt-tooling-shared-sub",
    "pins-odw-data-prod-sub",
  ])

  # Filter available subscriptions to only those we want to monitor
  # Keyed by subscription_id for stable for_each
  service_health_subscriptions = {
    for sub in data.azurerm_subscriptions.available.subscriptions :
    sub.subscription_id => sub
    if contains(local.monitored_subscription_names, sub.display_name)
  }
}
