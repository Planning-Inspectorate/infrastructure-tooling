# Shared Front Door instance for non-production environments
resource "azurerm_cdn_frontdoor_profile" "common" {
  name                = "pins-fd-common-tooling"
  resource_group_name = azurerm_resource_group.common.name
  sku_name            = "Premium_AzureFrontDoor"

  tags = local.tags
}

# Shared endpoints, one for each service
resource "azurerm_cdn_frontdoor_endpoint" "common" {
  for_each = toset(["appeals", "applications", "crowndev", "template", "scheduling", "peas", "local-plans"])

  name                     = "pins-fde-${each.key}"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.common.id

  tags = local.tags
}

#front door monitoring log analytics
resource "azurerm_log_analytics_workspace" "common" {
  name                = "pins-log-common-tooling"
  location            = module.azure_region_primary.location
  resource_group_name = azurerm_resource_group.common.name
  sku                 = "PerGB2018"
  retention_in_days   = 30

  tags = local.tags
}

#front door monitoring - diagnostic setting
resource "azurerm_monitor_diagnostic_setting" "web_front_door" {
  name                       = "pins-fd-mds-common-tooling"
  target_resource_id         = azurerm_cdn_frontdoor_profile.common.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.common.id

  enabled_log {
    category = "FrontdoorWebApplicationFirewallLog"
  }

  metric {
    category = "AllMetrics"
  }

  lifecycle {
    ignore_changes = [
      enabled_log,
      metric
    ]
  }
}
