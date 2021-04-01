#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*
# Create a Policy in Azure 
#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*


# Provider Block

provider "azurerm" {
    version         =   ">= 2.20"
    client_id       =   var.client_id
    client_secret   =   var.client_secret
    subscription_id =   var.subscription_id
    tenant_id       =   var.tenant_id
    
    features {}
}

# Policy Definition

resource "azurerm_policy_definition" "this" {
  name              =       var.policyVars["Definition-Name"]
  policy_type       =       var.policyVars["Policy-Type"]
  mode              =       var.policyVars["Mode"]
  display_name      =       var.policyVars["Definition-Name"]

  policy_rule = <<POLICY_RULE
    {
    "if": {
      "not": {
        "field": "location",
        "in": "[parameters('allowedLocations')]"
      }
    },
    "then": {
      "effect": "deny"
    }
  }
POLICY_RULE


  parameters = <<PARAMETERS
    {
    "allowedLocations": {
      "type": "Array",
      "metadata": {
        "description": "The list of allowed locations for resources.",
        "displayName": "Allowed locations",
        "strongType": "location"
      }
    }
  }
PARAMETERS

}


# Create a Resource Group in the allowed location

resource "azurerm_resource_group" "this" {
  name              =   "Azure-Policy-Allow-RG"
  location          =   "East US"
}


# Policy Assignment


resource "azurerm_policy_assignment" "this" {
  name                 =    var.policyVars["Assignment-Name"]
  scope                =    azurerm_resource_group.this.id
  policy_definition_id =    azurerm_policy_definition.this.id
  description          =    var.policyVars["Assignment-Description"]
  display_name         =    var.policyVars["Assignment-Name"]

  metadata = <<METADATA
    {
    "category": "General"
    }
METADATA

  parameters = <<PARAMETERS
{
  "allowedLocations": {
    "value": [ "East US" ]
  }
}
PARAMETERS

}



