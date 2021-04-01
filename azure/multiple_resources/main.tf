#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#
#*          Create multiple resources using for_each   *#
#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#

#
# - Create multiple Resource Groups
#

resource "azurerm_resource_group" "rg" {
    for_each              =   var.resource_group
    name                  =   each.key
    location              =   each.value
    tags                  =   var.tags
}

#
# - Create a Virtual Network
#


resource "azurerm_virtual_network" "vnet" {
  resource_group_name   =   azurerm_resource_group.rg["Dev-RG"].name
  name                  =   var.virtual_network["name"]
  location              =   azurerm_resource_group.rg["Dev-RG"].location
  address_space         =   [var.virtual_network["address_range"]]
  tags                  =   var.tags
}


#
# - Create multiple Subnets inside the virtual network
#

resource "azurerm_subnet" "sn" {
   for_each             =   var.subnet
   name                 =   each.key
   resource_group_name  =   azurerm_resource_group.rg["Dev-RG"].name
   virtual_network_name =   azurerm_virtual_network.vnet.name
   address_prefixes     =   [each.value]
}