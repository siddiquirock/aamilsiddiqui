terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "4.41.0"
    }
  }
}

provider "azurerm" {
   subscription_id = "987e5914-628e-4e9a-8c8f-d7fa87735002"
  features {
    
  
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

  
   
