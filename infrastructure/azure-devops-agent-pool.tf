resource "azurerm_linux_virtual_machine_scale_set" "azure_devops_agent_pool" {
  #checkov:skip=CKV_AZURE_49: SSH key authentication not required
  #checkov:skip=CKV_AZURE_97: Encryption at host not required
  #checkov:skip=CKV_AZURE_149: Password authentication required
  for_each = local.agent_pools

  name                = each.value["name"]
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

  source_image_id = data.azurerm_image.azure_agents.id

  boot_diagnostics {
    storage_account_uri = null
  }

  network_interface {
    enable_accelerated_networking = true
    name                          = each.value["nic_name"]
    primary                       = true

    ip_configuration {
      name      = "default"
      primary   = true
      subnet_id = azurerm_subnet.azure_agents.id
    }
  }

  os_disk {
    caching              = "ReadOnly"
    storage_account_type = "Standard_LRS"

    diff_disk_settings {
      option = "Local"
    }
  }

  lifecycle {
    ignore_changes = [
      automatic_instance_repair,
      automatic_os_upgrade_policy,
      extension,
      instances,
      tags
    ]
  }
}
