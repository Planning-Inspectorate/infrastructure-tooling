packer {
  required_plugins {
    azure = {
      source  = "github.com/hashicorp/azure"
      version = "~> 2"
    }
  }
}

source "azure-arm" "azure-agents" {
  azure_tags = {
    Project          = "tooling"
    CreatedBy        = "packer"
    NodeVersion      = "22.22"
    TerraformVersion = "1.15.5"
  }
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
  subscription_id = var.subscription_id
}

build {
  name = "azure-devops-agents-arm"

  source "source.azure-arm.azure-agents" {
    # Publish directly into an Azure Compute Gallery image definition.
    # Managed images do not support the Arm64 CPU architecture, so a gallery
    # destination is required for Arm64 images.
    shared_image_gallery_destination {
      resource_group = var.tooling_resource_group_name
      gallery_name   = var.gallery_name
      image_name     = var.gallery_image_definition
      image_version  = var.image_version
    }

    os_type         = "Linux"
    image_publisher = "canonical"
    image_offer     = "0001-com-ubuntu-server-jammy"
    image_sku       = "22_04-lts-arm64"

    location = "UK South"
    vm_size  = "Standard_D4pds_v6"
  }

  provisioner "shell" {
    execute_command = "chmod +x {{ .Path }}; {{ .Vars }} sudo -E bash -e '{{ .Path }}'"
    script          = "${path.cwd}/tools.sh"
  }
}

variable "client_id" {
  description = "The ID of the service principal used to build the image"
  type        = string
}

variable "client_secret" {
  description = "The client secret of the service principal used to build the image"
  type        = string
}

variable "subscription_id" {
  description = "The ID of the subscription containing the service principal used to build the image"
  type        = string
}

variable "tenant_id" {
  description = "The ID of the tenant containing the service principal used to build the image"
  type        = string
}

variable "tooling_resource_group_name" {
  description = "The name of the Tooling resource group where the image will be created"
  type        = string
}

variable "gallery_name" {
  description = "The name of the Azure Compute Gallery to publish the image into"
  type        = string
}

variable "gallery_image_definition" {
  description = "The name of the gallery image definition (must be the Arm64 definition)"
  type        = string
  default     = "azure-agents-arm64"
}

variable "image_version" {
  description = "The gallery image version in major.minor.patch format (e.g. 2026.6.26). Segments must be numeric with no leading zeros."
  type        = string
}

