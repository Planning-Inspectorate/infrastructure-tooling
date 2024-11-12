# Shared Front Door instance for non-production environments
resource "azurerm_cdn_frontdoor_profile" "common" {
  name                = "pins-fd-common-tooling"
  resource_group_name = azurerm_resource_group.common.name
  sku_name            = "Premium_AzureFrontDoor"

  tags = local.tags
}

# Shared endpoints, one for each service
resource "azurerm_cdn_frontdoor_endpoint" "common" {
  for_each = toset(["appeals", "applications", "crowndev", "template"])

  name                     = "pins-fde-${each.key}"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.common.id

  tags = local.tags
}
