frontdoor_service_principal = "c73a3f61-aa0a-4450-b3f8-303d72bf57a9"
primary_region              = "uk-south"
secondary_region            = "uk-west"

environment_vnets = {
  dev = {
    name           = "pins-vnet-common-dev-uks-001"
    resource_group = "pins-rg-common-dev-uks-001"
  }

  test = {
    name           = "pins-vnet-common-test-uks-001"
    resource_group = "pins-rg-common-test-uks-001"
  }

  prod = {
    name           = "pins-vnet-common-prod-uks-001"
    resource_group = "pins-rg-common-prod-uks-001"
  }
}
