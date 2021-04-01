#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#
#*   Storage account with Network Rules - Variables    *#
#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#

# Prefix and Tags

variable "prefix" {
    description =   "Prefix to append to all resource names"
    type        =   string
    default     =   "jenkins"
}

variable "tags" {
    description =   "Resouce tags"
    type        =   map(string)
    default     =   {
        "author"        =   "Vamsi"
        "deployed_with" =   "Terraform"
    }
}

# Resource Group

variable "location" {
    description =   "Location of the resource group"
    type        =   string
    default     =   "East US"
}

# Vnet and Subnet

variable "vnet_address_range" {
    description =   "IP Range of the virtual network"
    type        =   string
    default     =   "10.0.0.0/16"
}

variable "subnet_address_range" {
    description =   "IP Range of the virtual network"
    type        =   string
    default     =   "10.0.1.0/24"
}

# Storage account

variable "saVars" {
    description  =  "Variables for Storage account"
    type         =  map(string)
    default      =  {
        "name"                          =    "vamsisa"
        "account_kind"                  =    "StorageV2"
        "account_tier"                  =    "Standard"
        "access_tier"                   =    "Hot"
        "account_replication_type"      =    "LRS"
        "default_action"                =    "Deny"
        "ip_rules"                      =    "<IP_ADDRESS>"
        "bypass"                        =    "None"
    }
}

variable "blobs" {
    description     =       "Files to upload to the container"
    type            =       map(string)
    default         =       {
        "index.html"    =   "./index.html"
        "404.html"      =   "./404.html"
    }
}

