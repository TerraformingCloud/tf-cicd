#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*
# Create a Linux VM in an existing RG and VNET
#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*

data "azurerm_resource_group" "rg" {
    name        =   "Jenkins"
}


data "azurerm_virtual_network" "vnet" {
    name                    =   "Test-vnet"
    resource_group_name     =   data.azurerm_resource_group.rg.name
}

data "azurerm_subnet" "web" {
    name                    =   "Test-web-subnet"
    virtual_network_name    =    data.azurerm_virtual_network.vnet.name
    resource_group_name     =    data.azurerm_resource_group.rg.name
}


#
# - Public IP (To Login to Linux VM)
#

resource "azurerm_public_ip" "pip" {
    name                            =     "linuxvm-public-ip"
    resource_group_name             =     data.azurerm_resource_group.rg.name
    location                        =     data.azurerm_resource_group.rg.location
    allocation_method               =     var.allocation_method[0]
    tags                            =     var.tags
}

#
# - Create a Network Interface Card for Virtual Machine
#

resource "azurerm_network_interface" "nic" {
    name                              =   "linuxvm-nic"
    resource_group_name               =   data.azurerm_resource_group.rg.name
    location                          =   data.azurerm_resource_group.rg.location
    tags                              =   var.tags
    ip_configuration                  {
        name                          =  "linux-nic-ipconfig"
        subnet_id                     =   data.azurerm_subnet.web.id
        public_ip_address_id          =   azurerm_public_ip.pip.id
        private_ip_address_allocation =   var.allocation_method[1]
    }
}


#
# - Create a Linux Virtual Machine
# 

resource "azurerm_linux_virtual_machine" "vm" {
    name                              =   "linuxvm"
    resource_group_name               =   data.azurerm_resource_group.rg.name
    location                          =   data.azurerm_resource_group.rg.location
    network_interface_ids             =   [azurerm_network_interface.nic.id]
    size                              =   var.virtual_machine_size
    computer_name                     =   var.computer_name
    admin_username                    =   var.admin_username
    admin_password                    =   var.admin_password
    disable_password_authentication   =   false

    os_disk  {
        name                          =   "linuxvm-os-disk"
        caching                       =   var.os_disk_caching
        storage_account_type          =   var.os_disk_storage_account_type
        disk_size_gb                  =   var.os_disk_size_gb
    }

    source_image_reference {
        publisher                     =   var.publisher
        offer                         =   var.offer
        sku                           =   var.sku
        version                       =   var.vm_image_version
    }

    tags                              =   var.tags

}

