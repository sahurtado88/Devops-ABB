# Terraform Block
terraform {
  backend "azurerm" {
    resource_group_name  = "Terraform"
    storage_account_name = "terraformsahr"
    container_name       = "tfstatefile"
    key                  = "terraform.tfstate"
  }
  required_version = ">= 1.0.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.99.0"
    }
  }
}