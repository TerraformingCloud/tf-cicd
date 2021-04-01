#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#
#*          Azure Storage Account                      *#
#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#


provider "azurerm" {
    version         =   ">= 2.10"
    client_id       =   var.client_id
    client_secret   =   var.client_secret
    subscription_id =   var.subscription_id
    tenant_id       =   var.tenant_id
    
    features {}
}
#
# - Create a Resource Group
#
resource "azurerm_resource_group" "rg" {
    name                  =   var.rgVars["name"]
    location              =   var.rgVars["location"]
}

#
# - Create a Random string to append to Storage account name
#

resource "random_string" "sa_name" {
   length   =   5
   special  =   false
   lower    =   true
   upper    =   false
   number   =   false
}

#
# - Create a Storage account with Network Rules
#

resource "azurerm_storage_account" "sa" {
    count                         =    var.saCount
    name                          =    "sa${random_string.sa_name.result}${count.index+1}"
    resource_group_name           =    azurerm_resource_group.rg.name
    location                      =    azurerm_resource_group.rg.location
    account_tier                  =    var.saVars["account_tier"]
    account_replication_type      =    var.saVars["account_replication_type"]
}

resource "azurerm_storage_container" "sc" {
    count                         =     var.saCount
    name                          =     var.saVars["container_name"]
    storage_account_name          =     element(azurerm_storage_account.sa.*.name, count.index)
    container_access_type         =     var.saVars["container_access_type"]
}

// resource "local_file" "creds" {
//     filename                      =     "./sacreds.txt"
//     content                       =     join(",", [azurerm_storage_account.sa.name], [azurerm_storage_account.sa.primary_access_key] )
// }



