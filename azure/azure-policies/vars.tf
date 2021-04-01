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


# Policy Variables

variable "policyVars" {
    description     =       "Policy Definition and Policy Assignment Variables"
    type            =       map(string)
    default         =       {
        "Definition-Name"           =   "allowed-location-only"
        "Policy-Type"               =   "Custom"
        "Mode"                      =   "All"
        "Assignment-Name"           =   "allowed-location-assigment"
        "Assignment-Description"    =   "This policy denies creation of any resources outside allowed location"
    }
}