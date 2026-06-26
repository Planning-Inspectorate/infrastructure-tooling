# Action Group for Azure Service Health Alerts
resource "azurerm_monitor_action_group" "azure_service_alerts" {
  name                = "pins-ag-azure-service-alerts"
  short_name          = "AzureService"
  resource_group_name = azurerm_resource_group.common.name
  location            = "global"

  lifecycle {
    # Additional email receivers are managed outside Terraform (e.g. via Azure Portal),
    # so we intentionally ignore drift in the email_receiver configuration.
    ignore_changes = [email_receiver]
  }

  tags = local.tags
}

# Service health alerts for tooling sub
# this alert must be in the same sub as the sub being monitored
resource "azurerm_monitor_activity_log_alert" "tooling_service_health" {
  name                = "Azure Service health - tooling"
  resource_group_name = azurerm_resource_group.common.name
  scopes              = [data.azurerm_subscription.current.id]
  enabled             = true
  location            = "global"

  criteria {
    category = "ServiceHealth"
    service_health {
      events    = ["Incident"]
      locations = ["Global", "UK South", "UK West", "Sweden Central"]
    }
  }

  action {
    action_group_id = azurerm_monitor_action_group.azure_service_alerts.id
  }

  tags = local.tags
}
