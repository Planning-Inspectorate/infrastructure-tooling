resource "azurerm_resource_group" "tooling" {
  name     = "pins-rg-${local.resource_suffix}"
  location = var.location
  tags     = local.tags
}

resource "azurerm_resource_group" "common" {
  name     = "pins-rg-common-tooling"
  location = var.location
  tags     = local.tags
}

resource "azurerm_subnet" "azure_agents" {
  name                              = "pins-snet-azure-agents-${local.resource_suffix}"
  resource_group_name               = azurerm_resource_group.tooling.name
  virtual_network_name              = azurerm_virtual_network.tooling.name
  address_prefixes                  = ["10.10.0.0/24"] # 256 IPs
  private_endpoint_network_policies = "Enabled"
}

resource "azurerm_virtual_network" "tooling" {
  name                = "pins-vnet-${local.resource_suffix}"
  resource_group_name = azurerm_resource_group.tooling.name
  location            = azurerm_resource_group.tooling.location
  address_space       = ["10.10.0.0/16"] # 65536 IPs

  tags = local.tags
}

variable "location" {
  description = "The primary region resources are deployed to in slug format e.g. 'uk-south'"
  type        = string
  default     = "uksouth"
}

resource "random_password" "agents_admin_password" {
  length  = 20
  special = true
}

resource "azurerm_key_vault_secret" "agents_admin_password" {
  #checkov:skip=CKV_AZURE_41: TODO: Secret rotation
  content_type = "text/plain"
  key_vault_id = data.azurerm_key_vault.tooling_key_vault.id
  name         = "agents-admin-password"
  value        = random_password.agents_admin_password.result

  tags = local.tags

  lifecycle {
    ignore_changes = [
      value,
      expiration_date
    ]
  }
}
