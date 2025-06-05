module "azure_region_primary" {
  #checkov:skip=CKV_TF_1: "Ensure Terraform module sources use a commit hash
  source  = "claranet/regions/azurerm"
  version = "8.0.2"

  azure_region = var.primary_region
}

module "azure_region_secondary" {
  #checkov:skip=CKV_TF_1: "Ensure Terraform module sources use a commit hash
  source  = "claranet/regions/azurerm"
  version = "8.0.2"

  azure_region = var.secondary_region
}
