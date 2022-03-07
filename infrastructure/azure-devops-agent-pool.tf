resource "azurerm_linux_virtual_machine_scale_set" "azure_devops_agent_pool" {
  #checkov:skip=CKV_AZURE_49: SSH key authentication not required
  #checkov:skip=CKV_AZURE_97: Encryption at host not required
  name                = "pins-vmss-${local.resource_suffix}"
  resource_group_name = azurerm_resource_group.tooling.name
  location            = azurerm_resource_group.tooling.location
  sku                 = "Standard_D2ds_v5"
  instances           = 2

  overprovision          = false
  single_placement_group = false

  admin_username                  = "adminuser"
  admin_password                  = azurerm_key_vault_secret.agents_admin_password.value
  disable_password_authentication = false

  platform_fault_domain_count = 1

  boot_diagnostics {
    storage_account_uri = null
  }

  network_interface {
    enable_accelerated_networking = true
    name                          = "pins-vnet-azure-agents-nic-${local.resource_suffix}"
    primary                       = true

    ip_configuration {
      name      = "default"
      primary   = true
      subnet_id = azurerm_subnet.azure_agents.id
    }
  }

  os_disk {
    caching              = "ReadOnly"
    storage_account_type = "StandardSSD_LRS"

    diff_disk_settings {
      option = "Local"
    }
  }

  source_image_reference {
    publisher = "canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }

  lifecycle {
    ignore_changes = all
  }
}
