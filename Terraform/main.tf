provider "azurerm" {
  #resource_provider_registrations = "none" # This is only required when the User, Service Principal, or Identity running Terraform lacks the permissions to register Azure Resource Providers.
  features {}
  subscription_id = "e980f24d-8d22-4f8b-9acf-43e254fb0837"
}

terraform {
  backend "azurerm" {
    resource_group_name  = "rg-pipeline-project"
    storage_account_name = "pipelineprojtfstate"
    container_name       = "tfstate"
    key                  = "pipeline-project.tfstate"
  }
}
resource "azurerm_resource_group" "rg" {
  name     = "rg-pipeline-project"
  location = var.location
}

resource "azurerm_container_registry" "acr" {
  name                = "mypipelineacr"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "Basic"
  admin_enabled       = true

}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = "aks-pipeline-cluster"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "aks-pipeline-cluster-dns"

  default_node_pool {
    name       = "agentpool"
    node_count = 1
    vm_size    = "Standard_DC2ads_v5"
    zones      = ["1", "2"]
  }
  node_os_upgrade_channel = "None"
  oidc_issuer_enabled = true

  workload_identity_enabled = true

  identity {
    type = "SystemAssigned"
  }



}