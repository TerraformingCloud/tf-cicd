#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*
# KeyVault - Variables
#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*


variable "tags" {
    description =   "Resouce tags"
    type        =   map(string)
    default     =   {
        "author"        =   "Vamsi"
        "deployed_with" =   "Terraform"
    }
}

# Service Principal Variables

variable "client_id" {
    description =   "Client ID (APP ID) of the application"
    type        =   string
}

variable "client_secret" {
    description =   "Client Secret of the application"
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


#
# - Key Vault Variables
#

variable "kvVars" {
  description     =     "Variables of Key Vault resource"
  type            =     map(string)
  default         =     {
    Name                    =         "terraform-azure-kv13"
    SKU                     =         "standard"
    Disk-Encryption         =         "false"
    Deployment              =         "true"
    Template-Deployment     =         "false"
    Soft-Delete             =         "false"
    Purge-Protection        =         "false"
    Group-Object-ID         =         "21973edd-f194-4640-b3df-dcc51512ac83"
    User-Object-ID          =         "49a48b23-b093-4c68-a219-75a535b73921"
    App-Object-ID           =         "4a42b988-20ac-4d8e-b6a3-44cec9767268"
    
  }
}

variable "kvsecrets_username" {
  default   =   "sqladmin"
}

variable "kvsecrets_password" {
  default   =   "Password123!"
}

variable "kvSecret" {
  description     =     "Variables of Key Vault Secret resource"
  type            =     map(string)
  default         =     {
      Global-SQL-Username     =       "sqladmin"
      Global-SQL-Password     =       "Password123!"
  }
}

variable "kvTags" {
  description     =     "Tags for Key Vault"
  type            =     map(string)
  default         =     {
      Service                 =        "KeyVault"
      ServiceType             =        "Secrets-Management"
  }
}

variable "key_permissions" {
  description     =     "Key Permissions for Access Policy"
  type            =     list(string)
  default         =     ["get", "list", "create", "import", "delete"]
}

variable "secret_permissions" {
  description     =     "Secret Permissions for Access Policy"
  type            =     list(string)
  default         =     ["get", "set", "list", "delete"]
}

variable "certificate_permissions" {
  description     =     "Certificate Permissions for Access Policy"
  type            =     list(string)
  default         =     ["get", "list", "create", "import", "delete"]
}

variable "storage_permissions" {
  description     =     "Storgae Permissions for Access Policy"
  type            =     list(string)
  default         =     ["get", "list", "set", "delete"]
}

