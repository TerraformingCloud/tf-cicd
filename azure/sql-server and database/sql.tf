#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*
#*            SQL Server and Database                     #*
#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*

#
# - Provider Block
#

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

resource "azurerm_resource_group" "ss" {
    name                            =      var.rgVars["Name"]
    location                        =      var.rgVars["Location"]
    tags                            =      var.tags
}


#
# - SQL Server
#

resource "azurerm_sql_server" "ss" {
  name                              =       var.sqlVars["ServerName"]
  resource_group_name               =       azurerm_resource_group.ss.name
  location                          =       azurerm_resource_group.ss.location
  version                           =       var.sqlVars["Server-Version"]
  administrator_login               =       var.sqlVars["Username"]
  administrator_login_password      =       var.sqlVars["Password"]
  tags                              =       var.tags
}


#
# - SQL Server Firewall Rules
#

resource "azurerm_sql_firewall_rule" "ss" {
  for_each                          =      var.sqlFwIPs
  name                              =      each.key
  resource_group_name               =      azurerm_resource_group.ss.name
  server_name                       =      azurerm_sql_server.ss.name
  start_ip_address                  =      each.value
  end_ip_address                    =      each.value
}

#
# - SQL Database
#

resource "azurerm_sql_database" "ss" {
  name                              =      var.sqlVars["DBName"]
  resource_group_name               =      azurerm_resource_group.ss.name
  location                          =      azurerm_resource_group.ss.location
  server_name                       =      azurerm_sql_server.ss.name
  create_mode                       =      var.sqlVars["CreateMode"]
  edition                           =      var.sqlVars["Edition"]
  tags                              =      var.tags
}