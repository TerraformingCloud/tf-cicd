#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*
# Create an AKS Cluster in Azure - Variables
#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*

variable "env" {
    description     =       "Name of the environment"
    type            =       string
}

variable "rglocation" {
    description     =       "Location of RG"
    type            =       string
    default         =       "East US"
}

variable "tags"   {
    description     =       "Resource Tags"
    type            =       map(string)
    default         =       {
        author      =       "vamsi"
        service     =       "aks"
        env         =       "dev"
    }
}