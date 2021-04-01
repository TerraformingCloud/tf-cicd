#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*
# Create a Windows 10 VM in an existing RG and VNET
#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*

data "azurerm_resource_group" "rg" {
    name        =   "windowsserver-rg"
}


data "azurerm_virtual_network" "vnet" {
    name                    =   "windowsserver-vnet"
    resource_group_name     =   data.azurerm_resource_group.rg.name
}

data "azurerm_subnet" "member" {
    name                    =   "member-subnet"
    virtual_network_name    =    data.azurerm_virtual_network.vnet.name
    resource_group_name     =    data.azurerm_resource_group.rg.name
}

data "azurerm_storage_account" "sa" {
    name                    =   "domainpsscripts"
    resource_group_name     =   data.azurerm_resource_group.rg.name
}


#
# - Public IP (To Login to Linux VM)
#

resource "azurerm_public_ip" "pip" {
    name                            =     "${var.prefix}-public-ip"
    resource_group_name             =     data.azurerm_resource_group.rg.name
    location                        =     data.azurerm_resource_group.rg.location
    allocation_method               =     var.allocation_method[0]
    tags                            =     var.tags
}

#
# - Create a Network Interface Card for Virtual Machine
#

resource "azurerm_network_interface" "nic" {
    name                              =   "${var.prefix}-nic"
    resource_group_name               =   data.azurerm_resource_group.rg.name
    location                          =   data.azurerm_resource_group.rg.location
    tags                              =   var.tags
    ip_configuration                  {
        name                          =  "${var.prefix}-nic-ipconfig"
        subnet_id                     =   data.azurerm_subnet.member.id
        public_ip_address_id          =   azurerm_public_ip.pip.id
        private_ip_address_allocation =   var.allocation_method[1]
    }
}


#
# - Create a Windows 10 Virtual Machine
#

resource "azurerm_windows_virtual_machine" "vm" {
    name                              =   "${var.prefix}-vm"
    resource_group_name               =   data.azurerm_resource_group.rg.name
    location                          =   data.azurerm_resource_group.rg.location
    network_interface_ids             =   [azurerm_network_interface.nic.id]
    size                              =   var.virtual_machine_size
    computer_name                     =   var.computer_name
    admin_username                    =   var.admin_username
    admin_password                    =   var.admin_password

    os_disk  {
        name                          =   "${var.prefix}-os-disk"
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

resource "azurerm_virtual_machine_extension" "domainjoin" {
  name                  =        "Domain-Join"
  virtual_machine_id    =        azurerm_windows_virtual_machine.vm.id
  publisher             =        "Microsoft.Compute"
  type                  =        "CustomScriptExtension"
  type_handler_version  =        "1.10"

  protected_settings = <<PROTECTED_SETTINGS
    {
      "commandToExecute"    :   "powershell -ExecutionPolicy Unrestricted -File domainjoin.ps1",
      "storageAccountName"  :   "${data.azurerm_storage_account.sa.name}",
      "storageAccountKey"   :   "${data.azurerm_storage_account.sa.primary_access_key}"
    }
  PROTECTED_SETTINGS

  settings = <<SETTINGS
    {
        "fileUris"      : [ "https://domainpsscripts.blob.core.windows.net/psscripts/domainjoin.ps1" ]
    }
  SETTINGS

  depends_on      =       [azurerm_windows_virtual_machine.vm]
}

// resource "azurerm_virtual_machine_extension" "domjoin" {
//     name                 =        "DomainJoin"
//     virtual_machine_id   =        azurerm_windows_virtual_machine.vm.id
//     publisher            =        "Microsoft.Compute"
//     type                 =        "JsonADDomainExtension"
//     type_handler_version =        "1.3"

//     settings = <<SETTINGS
//     {
//         "Name"      :   "burugadda.local",
//         "User"      :   "burugadda.local\\winserveradmin",
//         "Restart"   :   "true",
//         "Options"   :   "3"
//     }
//     SETTINGS

//     protected_settings = <<PROTECTED_SETTINGS
//     {
//         "Password"  :   "${var.admin_password}"
//     }
//     PROTECTED_SETTINGS

//     depends_on      =       [azurerm_windows_virtual_machine.vm, azurerm_virtual_machine_extension.setdns]
// } 