#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*
# Create a Windows Server 2019 VM 
#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*

#
# - Create a Resource Group
#

resource "azurerm_resource_group" "rg" {
    name                  =   "${var.prefix}-rg"
    location              =   var.location
    tags                  =   var.tags
}

#
# - Create a Virtual Network
#

resource "azurerm_virtual_network" "vnet" {
    name                  =   "${var.prefix}-vnet"
    resource_group_name   =   azurerm_resource_group.rg.name
    location              =   azurerm_resource_group.rg.location
    address_space         =   [var.vnet_address_range]
    tags                  =   var.tags
}

#
# - Create a Subnet inside the virtual network
#

resource "azurerm_subnet" "sn" {
    for_each              =   var.subnets
    name                  =   each.key
    resource_group_name   =   azurerm_resource_group.rg.name
    virtual_network_name  =   azurerm_virtual_network.vnet.name
    address_prefixes      =   [each.value]
}

#
# - Create a Network Security Group
#

resource "azurerm_network_security_group" "nsg" {
    name                        =       "${var.prefix}-web-nsg"
    resource_group_name         =       azurerm_resource_group.rg.name
    location                    =       azurerm_resource_group.rg.location
    tags                        =       var.tags

    security_rule {
    name                        =       "Allow_RDP"
    priority                    =       1000
    direction                   =       "Inbound"
    access                      =       "Allow"
    protocol                    =       "Tcp"
    source_port_range           =       "*"
    destination_port_range      =       3389
    source_address_prefix       =       "YOUR_IP" 
    destination_address_prefix  =       "*"
    
    }
}


#
# - Subnet-NSG Association
#

resource "azurerm_subnet_network_security_group_association" "server-subnet-nsg" {
    subnet_id                    =       azurerm_subnet.sn["server-subnet"].id
    network_security_group_id    =       azurerm_network_security_group.nsg.id
}

resource "azurerm_subnet_network_security_group_association" "member-subnet-nsg" {
    subnet_id                    =       azurerm_subnet.sn["member-subnet"].id
    network_security_group_id    =       azurerm_network_security_group.nsg.id
}

#
# - Public IP (To Login to Linux VM)
#

resource "azurerm_public_ip" "pip" {
    name                            =     "${var.prefix}-public-ip"
    resource_group_name             =     azurerm_resource_group.rg.name
    location                        =     azurerm_resource_group.rg.location
    allocation_method               =     var.allocation_method[0]
    tags                            =     var.tags
}

#
# - Create a Network Interface Card for Virtual Machine
#

resource "azurerm_network_interface" "nic" {
    name                              =   "${var.prefix}-nic"
    resource_group_name               =   azurerm_resource_group.rg.name
    location                          =   azurerm_resource_group.rg.location
    tags                              =   var.tags
    ip_configuration                  {
        name                          =  "${var.prefix}-nic-ipconfig"
        subnet_id                     =   azurerm_subnet.sn["server-subnet"].id
        public_ip_address_id          =   azurerm_public_ip.pip.id
        private_ip_address_allocation =   var.allocation_method[1]
    }
}


#
# - Create a Windows Server Virtual Machine
#

#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*
# Create a Windows Server 2019 VM 
#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*

resource "azurerm_windows_virtual_machine" "vm" {
    name                              =   "${var.prefix}-vm"
    resource_group_name               =   azurerm_resource_group.rg.name
    location                          =   azurerm_resource_group.rg.location
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

resource "azurerm_virtual_machine_extension" "adds" {
  name                  =        "Domain-Controller-Services"
  virtual_machine_id    =        azurerm_windows_virtual_machine.vm.id
  publisher             =        "Microsoft.Compute"
  type                  =        "CustomScriptExtension"
  type_handler_version  =        "1.10"

  protected_settings = <<PROTECTED_SETTINGS
    {
      "commandToExecute"    :   "powershell -ExecutionPolicy Unrestricted -File adds.ps1",
      "storageAccountName"  :   "${azurerm_storage_account.scripts.name}",
      "storageAccountKey"   :   "${azurerm_storage_account.scripts.primary_access_key}"
    }
  PROTECTED_SETTINGS

  settings = <<SETTINGS
    {
        "fileUris"      : [ "https://domainpsscripts.blob.core.windows.net/psscripts/adds.ps1" ]
    }
  SETTINGS

  depends_on      =       [azurerm_windows_virtual_machine.vm]

}