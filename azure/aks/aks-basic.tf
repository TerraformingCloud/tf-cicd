#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*
# Create an AKS Cluster in Azure 
#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*

#
# - Create a Resource Group
#

resource "azurerm_resource_group" "rg" {
  name                  =   "${var.env}-aks-rg"
  location              =   var.rglocation
  tags                  =   var.tags
}

#
# - Create an AD Group for AKS Administration
#

resource "azuread_group" "aks_admins" {
  name                   =   "${var.env}-aks-administrators"
  description            =   "Kubernetes administrators"
}

#
# - AKS Version Data Source 
# 

data "azurerm_kubernetes_service_versions" "current" {
  location               =   azurerm_resource_group.rg.location
}


resource "azurerm_kubernetes_cluster" "aks" {
   name                  =    "${var.env}-aks-cluster"
   resource_group_name   =    azurerm_resource_group.rg.name
   location              =    azurerm_resource_group.rg.location     
   dns_prefix            =    "${var.env}-aks-cluster"
   kubernetes_version    =    data.azurerm_kubernetes_service_versions.current.latest_version
   node_resource_group   =    "${azurerm_resource_group.rg.name}-nodes-rg"
   
   default_node_pool {
    name                 =    "aksnode"
    orchestrator_version =    data.azurerm_kubernetes_service_versions.current.latest_version
    os_disk_size_gb      =    30
    vm_size              =    "Standard_DS2_v2"
    node_count           =    1
  }

  identity { 
    type                 =    "SystemAssigned" 
  }

  role_based_access_control {
    enabled                  = true
    azure_active_directory  {
      managed                = true
      admin_group_object_ids = [azuread_group.aks_admins.object_id]
    }
  }
}