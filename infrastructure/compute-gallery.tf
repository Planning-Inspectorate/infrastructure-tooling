# Azure Compute Gallery (Shared Image Gallery) for the build agent images.
# Required for Arm64 images: legacy managed images only support the x64 CPU
# architecture, so Arm64 agent images must be published as gallery image
# versions instead.
resource "azurerm_shared_image_gallery" "tooling" {
  name                = "pins_gallery_${replace(local.resource_suffix, "-", "_")}"
  resource_group_name = azurerm_resource_group.tooling.name
  location            = azurerm_resource_group.tooling.location
  description         = "Image gallery for Azure DevOps build agents"

  tags = local.tags
}

# Arm64 image definition. Packer publishes image versions into this definition.
resource "azurerm_shared_image" "azure_agents_arm64" {
  name                = "azure-agents-arm64"
  gallery_name        = azurerm_shared_image_gallery.tooling.name
  resource_group_name = azurerm_resource_group.tooling.name
  location            = azurerm_resource_group.tooling.location

  os_type            = "Linux"
  architecture       = "Arm64" # requires azurerm provider >= 3.10 (we use > 4)
  hyper_v_generation = "V2"    # Arm64 is always Generation 2

  identifier {
    publisher = "PlanningInspectorate"
    offer     = "azure-devops-agents"
    sku       = "arm64-ubuntu-2204"
  }

  tags = local.tags
}

