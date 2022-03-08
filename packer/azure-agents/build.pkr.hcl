build {
  name = "azure-devops-agents"

  source "source.azure-arm.azure-agents" {
    managed_image_resource_group_name = var.tooling_resource_group_name
    managed_image_name = "azure-agents"

    os_type =  "Linux"
    image_publisher = "canonical"
    image_offer = "0001-com-ubuntu-server-focal"
    image_sku = "20_04-lts"

    location = "UK South"
    vm_size = "Standard_D2ds_v5"
  }

  provisioner "shell" {
    script = file("${path.cwd}/tools.sh")
  }
}
