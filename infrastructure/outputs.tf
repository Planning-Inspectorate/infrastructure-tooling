output "acr_server_password" {
  description = "The admin password used to connect to the Container Registry"
  sensitive   = true
  value       = azurerm_container_registry.acr.admin_password
}

output "acr_server_url" {
  description = "The server URL used to connect to the Container Registry"
  sensitive   = true
  value       = azurerm_container_registry.acr.login_server
}

output "acr_server_username" {
  description = "The admin username used to connect to the Container Registry"
  sensitive   = true
  value       = azurerm_container_registry.acr.admin_username
}
