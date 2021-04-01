#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*
# KeyVault - Outputs
#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*

output "Resource-Names" {
    description     =   "Print the name of the resources"
    value           =   {
        Resource-Group-Name     =   azurerm_resource_group.rg.name
        KeyVault-Name           =   azurerm_key_vault.kv.name
    }
}
