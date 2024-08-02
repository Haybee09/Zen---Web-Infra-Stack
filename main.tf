terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm" #Specifies Provider
      version = "~> 3.0" 
    }
  }
}

provider "azurerm" {
  features {}
}

#Creates Resource Group in specified Location
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}