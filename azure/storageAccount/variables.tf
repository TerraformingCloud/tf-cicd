#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#
#*   Storage account - Variables                       *#
#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#

# Service Principal Variables

variable "client_id" {
    description =   "Client ID (APP ID) of the application"
    type        =   string
}

variable "client_secret" {
    description =   "Client Secret (Password) of the application"
    type        =   string
}

variable "subscription_id" {
    description =   "Subscription ID"
    type        =   string
}

variable "tenant_id" {
    description =   "Tenant ID"
    type        =   string
}

# Resource Group

variable "rgVars" {
    description =   "Resource group variables"
    type        =   map(string)
    default     =   {
        "name"      =   "Storage-Rg"
        "location"  =   "East US"    
    }
}


# Storage account


variable "saCount" {
    default     =   2
}

variable "saVars" {
    description  =  "Variables for Storage accounts and containers"
    type         =  map(string)
    default      =  {
        "account_tier"                  =    "Standard"
        "account_replication_type"      =    "LRS"
        "container_name"                =    "diagnostics"
        "container_access_type"         =    "private"
    }
}


