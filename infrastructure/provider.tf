terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.91.0"
    }
  }
}

provider "azurerm" {
  features {}
}

provider "azurerm" {
  alias           = "dev"
  subscription_id = "962e477c-0f3b-4372-97fc-a198a58e259e"

  features {}
}

provider "azurerm" {
  alias           = "test"
  subscription_id = "76cf28c6-6fda-42f1-bcd9-6d7dbed704ef"

  features {}
}

provider "azurerm" {
  alias           = "prod"
  subscription_id = "d1d6c393-2fe3-40af-ac27-f5b6bad36735"

  features {}
}
