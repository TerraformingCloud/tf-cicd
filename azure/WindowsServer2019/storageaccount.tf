


#
# - Create a Storage account and a Blob Container
#

resource "azurerm_storage_account" "scripts" {
    name                          =    "domainpsscripts"
    resource_group_name           =    azurerm_resource_group.rg.name
    location                      =    azurerm_resource_group.rg.location
    account_tier                  =    "Standard"
    account_replication_type      =    "LRS"
}

resource "azurerm_storage_container" "sc" {
    name                          =     "psscripts"
    storage_account_name          =     azurerm_storage_account.scripts.name
    container_access_type         =     "private"
}

resource "azurerm_storage_blob" "scripts" {
    for_each                      =     var.blobs
    name                          =     each.key
    storage_account_name          =     azurerm_storage_account.scripts.name
    storage_container_name        =     azurerm_storage_container.sc.name
    type                          =     "Block"
    source                        =     each.value
}
