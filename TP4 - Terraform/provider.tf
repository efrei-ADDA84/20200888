provider "azurerm" {
  features {}
  subscription_id            = var.azure_subscription_id
  skip_provider_registration = true
}

provider "tls" {}
