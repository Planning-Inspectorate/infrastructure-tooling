# Resources moved to infrastructure-agents/. Dropped from this state without destroying them in Azure.

###########
##### Fully understand the implications of removing these resources from the state without destroying them in Azure.
###########

removed {
  from = azurerm_linux_virtual_machine_scale_set.azure_devops_agent_pool

  lifecycle {
    destroy = false
  }
}

removed {
  from = azurerm_subnet.azure_agents

  lifecycle {
    destroy = false
  }
}

removed {
  from = azurerm_key_vault_secret.agents_admin_password

  lifecycle {
    destroy = false
  }
}

removed {
  from = random_password.agents_admin_password

  lifecycle {
    destroy = false
  }
}
