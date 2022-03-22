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
