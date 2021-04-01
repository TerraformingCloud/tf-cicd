#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*
#*            SQL Server and Database - Variables         #*
#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*

#
#- SPN Variables
#

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


#
# - Tags
#

variable "tags" {
    description     =   "Resource Tags"
    type            =   map(string)
    default         =   {
        "Author"        =   "Vamsi"
        "DeployedWith"  =   "Terraform"
        "Service"       =   "Azure SQL Server and Azure SQL Database"
    }
}



#
# - Resource Group Variables
#

variable "rgVars" {
  description     =   "Resource Group Variables"
  type            =   map(string)
  default         =   {
    "Name"        =     "Sql-Rg"
    "Location"    =     "East US"
  }
}



#
# - SQL Server Variables
#

variable "sqlVars" {
  description     =     "Variables of SQL Server and Database resources"
  type            =     map(string)
  default         =     {
      ServerName              =        "vamsi-sqlserver13"
      Server-Version          =        "12.0"
      Username                =        "Sqladmin"
      Password                =        "V@m$!Pass1325*"
      DBName                  =        "SQL-DB1"
      CreateMode              =        "Default"
      Edition                 =        "Basic"
  }
}


#
# - SQL Server Firewall Rules
#

variable "sqlFwIPs" {
  description     =     "Client IP Addresses to add to the Firewall"
  type            =     map(string)
  default         =     {
      AllowAzureServices     =         "0.0.0.0"
  }
}



