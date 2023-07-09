terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0.2"
    }
  }

  required_version = ">= 1.1.0"

  backend "azurerm" {
    resource_group_name  = "tfstate"
    storage_account_name = "tfstate28091"
    container_name       = "tfstate"
    key                  = "prod.mediawiki.tfstate"
    use_msi              = true
    subscription_id      = "2a15d277-529d-456b-8755-e9f9d8cc977a"
    tenant_id            = "2eebb3d6-43dd-4743-9c1c-7667632ec9d8"
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "mediawiki-rg" {
  name     = "mediawiki-rg"
  location = "eastus"
  tags = {
    environment = "Mediawiki demo"
  }
}

resource "random_pet" "prefix" {}

resource "azurerm_kubernetes_cluster" "mediawiki-k8s" {
  name                = "${random_pet.prefix.id}-aks"
  location            = azurerm_resource_group.mediawiki-rg.location
  resource_group_name = azurerm_resource_group.mediawiki-rg.name
  dns_prefix          = "${random_pet.prefix.id}-k8s"

  default_node_pool {
    name            = "default"
    node_count      = 1
    vm_size         = "Standard_B2s"
    os_disk_size_gb = 30
  }

  service_principal {
    client_id     = var.appId
    client_secret = var.password
  }

  role_based_access_control_enabled = true

  tags = {
    environment = "Mediawiki demo"
  }
}
