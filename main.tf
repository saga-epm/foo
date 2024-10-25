
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "azurerm" {
  features {}  
  subscription_id = "56d01180-6611-4eca-b2e4-31f57552288d"
}

data "azurerm_resource_group" "example" {
  name     = "Oliver"  
}
