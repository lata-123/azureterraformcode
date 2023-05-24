# Define the Azure provider
terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.57.0"
    }
  }
}

provider "azurerm" {
    
  features {}
}

# Create a resource group
resource "azurerm_resource_group" "rg" {
  name     = "my-resource-group"
  location = "East US"
}

# Create an Azure Container Registry (ACR)
resource "azurerm_container_registry" "acr" {
  name                     = "meraacr"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  sku                      = "Standard"
  admin_enabled            = false
}

# Create an Azure Kubernetes Service (AKS) cluster
resource "azurerm_kubernetes_cluster" "aks" {
  name                = "my-aks-cluster"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "myakscluster"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_DS2_v2"
  }

  identity {
    type = "SystemAssigned"
  }


}

# Output the ACR and AKS details
output "acr_details" {
  value = azurerm_container_registry.acr.login_server
}

