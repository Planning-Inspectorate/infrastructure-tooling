# Adopts resources previously managed by infrastructure/ so they are not recreated.
# Safe to delete once the first apply has succeeded.
locals {
  rg_id         = "/subscriptions/${var.subscription_id}/resourceGroups/pins-rg-${local.resource_suffix}"
  key_vault_url = "https://${replace("pinskv${local.resource_suffix}", "-", "")}.vault.azure.net"
}

import {
  for_each = local.agent_pools
  to       = azurerm_linux_virtual_machine_scale_set.azure_devops_agent_pool[each.key]
  id       = "${local.rg_id}/providers/Microsoft.Compute/virtualMachineScaleSets/${each.value.name}"
}

import {
  to = azurerm_subnet.azure_agents
  id = "${local.rg_id}/providers/Microsoft.Network/virtualNetworks/pins-vnet-${local.resource_suffix}/subnets/pins-snet-azure-agents-${local.resource_suffix}"
}

import {
  to = azurerm_key_vault_secret.agents_admin_password
  id = data.azurerm_key_vault_secret.agents_admin_password_existing.id
}
