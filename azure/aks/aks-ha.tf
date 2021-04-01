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
# - AKS Version Data Source 
# 

data "azurerm_kubernetes_service_versions" "current" {
  location               =   azurerm_resource_group.rg.location
}


resource "azurerm_kubernetes_cluster" "k8s" {
   name                  =    "${var.env}-aks-cluster"
   resource_group_name   =    azurerm_resource_group.rg.name
   location              =    azurerm_resource_group.rg.location     
   dns_prefix            =    "${var.env}-aks-cluster"
   kubernetes_version    =    data.azurerm_kubernetes_service_versions.current.latest_version
   node_resource_group   =    "${azurerm_resource_group.rg.name}-nodes-rg"
   
   default_node_pool {
    name                 =    "aksnode"
    availability_zones   =    [1, 2, 3]
    enable_auto_scaling  =    true
    max_count            =    3
    min_count            =    1
    orchestrator_version =    data.azurerm_kubernetes_service_versions.current.latest_version
    os_disk_size_gb      =    30
    vm_size              =    "Standard_DS2_v2"
    node_count           =    1
    type                 =    "VirtualMachineScaleSets"
  }

  addon_profile {
    kube_dashboard {
      enabled = true
    }
  }

  service_principal {
    client_id            =    var.client_id
    client_secret        =    var.client_secret
  }

  tags  =   {
    env         =   var.env
    created_on  =   formatdate("MMM DD, YYYY", "2020-11-11T12:52:22Z")
  }

  lifecycle   {
    ignore_changes  =   [default_node_pool[0].node_count]
  }

}