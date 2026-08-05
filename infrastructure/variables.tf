variable "environment" {
  description = "The environment resources are deployed to e.g. 'tooling'"
  type        = string
  default     = "tooling"
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
