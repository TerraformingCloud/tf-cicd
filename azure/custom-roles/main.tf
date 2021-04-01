#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*
# Create Custom Roles in Azure
#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*

data "azuread_client_config" "current" {}

data "azurerm_subscription" "primary" {}

resource "azurerm_role_definition" "custom" {
    name                    =       "Custom role for Users"
    scope                   =       "/subscriptions/xxx-xxx-xxxxxx/resourceGroups/Test1-rg"
    description             =       "Custom Role for Users to restrict access"

    permissions {
        actions             =     [ "Microsoft.Compute/virtualMachines/restart/action",
                                    "Microsoft.Compute/virtualMachines/deallocate/action",
                                    "Microsoft.Compute/virtualMachines/start/action" ]

        not_actions         =     []

        data_actions        =     ["Microsoft.Compute/virtualMachines/login/action"]
        not_data_actions    =     ["Microsoft.Compute/virtualMachines/loginAsAdmin/action"]
    }

    assignable_scopes       =   ["/subscriptions/xxx-xxx-xxxxxx/resourceGroups/Test1-rg"]

}

resource "azurerm_role_assignment" "custom" {
    scope               =   data.azurerm_subscription.primary.id
    role_definition_id  =   azurerm_role_definition.custom.id
    principal_id        =   "1234-5678-9012344"
}