variable "environment" {
  description = "The environment for the agents"
  type        = string
  default     = "tooling"
}

variable "subscription_id" {
  description = "Tooling subscription ID, used to build the resource IDs in imports.tf"
  type        = string
  default     = "edb1ff78-90da-4901-a497-7e79f966f8e2"
}

variable "location" {
  description = "The primary region resources are deployed to in slug format e.g. 'uk-south'"
  type        = string
  default     = "uksouth"
}
