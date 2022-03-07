data "azurerm_client_config" "current" {}

data "azurerm_virtual_network" "environments" {
  for_each = var.environment_vnets

  name                = each.value["name"]
  resource_group_name = each.value["resource_group"]
}
