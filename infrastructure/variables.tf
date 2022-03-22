variable "environment" {
  description = "The environment resources are deployed to e.g. 'tooling'"
  type        = string
  default     = "tooling"
}

variable "environment_vnets" {
  description = "A map containing the VNet name and resource group for each environment"
  type        = map(map(string))
  default     = {}
}

variable "frontdoor_service_principal" {
  description = "The object ID for the Front Door Service Principal configured at the tenant level"
  type        = string
}

variable "primary_region" {
  description = "The primary region resources are deployed to in slug format e.g. 'uk-south'"
  type        = string
  default     = "uk-south"
}

variable "secondary_region" {
  description = "The secondary region resources are deployed to for geo-replication in slug format e.g. 'uk-west'"
  type        = string
  default     = "uk-west"
}
