#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#
#*     Using Modules in Terraform - Create a Vnet    *#
#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#


#
# - Deploy a Vnet in Azure
#


module "vnet" {
    source                 =    "./child_module"
    resource_group_name    =    "Jenkins-RG"
    location               =    "East US"
    virtual_network_name   =    "Jenkins-Vnet"
    vnet_address_range     =    "10.0.0.0/16"
    subnet_name            =    "Webserver-Subnet"
    subnet_address_range   =    "10.0.1.0/24"

}
