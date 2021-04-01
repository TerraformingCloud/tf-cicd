#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#
#*   Storage accounts -  Outputs                       *#
#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#

output "storage_account_name" {
    description    =    "Name of the storage accounts"
    value          =    azurerm_storage_account.sa.*.name
}

output "storage_container_name" {
    description    =    "Name of the storage containers"
    value          =    azurerm_storage_container.sc.*.name
}

// output "sa_creds" {
//     description    =    "Store SA name and Access key"
//     value          =    {
//         SA-Name    =    azurerm_storage_account.sa.*.name
//         Access-key =    azurerm_storage_account.sa.*.primary_access_key  
//     }
// }