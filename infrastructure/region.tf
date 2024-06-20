module "azure_region_primary" {
  #checkov:skip=CKV_TF_1: "Ensure Terraform module sources use a commit hash" - Currently not required
  source  = "claranet/regions/azurerm"
  version = "4.2.1"

  azure_region = var.primary_region
}

module "azure_region_secondary" {
  #checkov:skip=CKV_TF_1: "Ensure Terraform module sources use a commit hash" - Currently not required
  source  = "claranet/regions/azurerm"
  version = "4.2.1"

  azure_region = var.secondary_region
}
