#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*
# Create a KeyVault  
#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*

# Terraform Block

terraform {
    required_providers {
        azurerm = {
            version =   ">= 2.20"
            source  =   "hashicorp/azurerm"
        }
    }
}

# Provider Block

provider "azurerm" {
    client_id       =   var.client_id
    client_secret   =   var.client_secret
    subscription_id =   var.subscription_id
    tenant_id       =   var.tenant_id
    
    features {}
}


data "azurerm_client_config" "current" {}


#
# - Create a Resource Group
#

resource "azurerm_resource_group" "rg" {
    name                  =   "KeyVault-rg"
    location              =   "East US"
    tags                  =   var.tags
}


#
# - Key Vault
#

resource "azurerm_key_vault" "kv" {
  name                              =       "terraform-azure-kv13"
  location                          =       azurerm_resource_group.rg.location
  resource_group_name               =       azurerm_resource_group.rg.name
  sku_name                          =       var.kvVars["SKU"]
  enabled_for_disk_encryption       =       var.kvVars["Disk-Encryption"]
  enabled_for_deployment            =       var.kvVars["Deployment"]
  enabled_for_template_deployment   =       var.kvVars["Template-Deployment"]
  tenant_id                         =       data.azurerm_client_config.current.tenant_id
  soft_delete_enabled               =       var.kvVars["Soft-Delete"]
  purge_protection_enabled          =       var.kvVars["Purge-Protection"]
  tags                              =       merge(var.tags, var.kvTags)
}

#
# - Key Vault Access Policies
#

# Access Policy for a Service Principal

resource "azurerm_key_vault_access_policy" "app" {
  key_vault_id                      =       azurerm_key_vault.kv.id
  tenant_id                         =       data.azurerm_client_config.current.tenant_id
  application_id                    =       var.client_id
  object_id                         =       var.kvVars["User-Object-ID"]
  key_permissions                   =       var.key_permissions
  secret_permissions                =       var.secret_permissions
  certificate_permissions           =       var.certificate_permissions
  storage_permissions               =       var.storage_permissions
}

# Access Policy for an AD User

resource "azurerm_key_vault_access_policy" "user" {
  key_vault_id                      =       azurerm_key_vault.kv.id
  tenant_id                         =       data.azurerm_client_config.current.tenant_id
  object_id                         =       var.kvVars["User-Object-ID"]
  key_permissions                   =       var.key_permissions
  secret_permissions                =       var.secret_permissions
  certificate_permissions           =       var.certificate_permissions
  storage_permissions               =       var.storage_permissions
}

# Access Policy for an AD Group

resource "azurerm_key_vault_access_policy" "group" {
  key_vault_id                      =       azurerm_key_vault.kv.id
  tenant_id                         =       data.azurerm_client_config.current.tenant_id
  object_id                         =       var.kvVars["Group-Object-ID"]
  key_permissions                   =       var.key_permissions 
  secret_permissions                =       var.secret_permissions
  certificate_permissions           =       var.certificate_permissions
  storage_permissions               =       var.storage_permissions 
}


#
# - Key Vault Secrets
#

resource "azurerm_key_vault_secret" "sec" {
  for_each                          =       var.kvSecretVars
  name                              =       each.key
  value                             =       each.value
  key_vault_id                      =       azurerm_key_vault.kv.id
}


