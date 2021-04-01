#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*
# Windows 10 VM - Variables
#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*

# Prefix

variable "prefix" {
    description =   "Prefix to append to all resource names"
    type        =   string
    default     =   "windows10"
}


#Tags

variable "tags" {
    description =   "Resouce tags"
    type        =   map(string)
    default     =   {
        "author"        =   "Vamsi"
        "deployed_with" =   "Terraform"
    }
}


# Public IP and NIC Allocation Method

variable "allocation_method" {
    description =   "Allocation method for Public IP Address and NIC Private ip address"
    type        =   list(string)
    default     =   ["Static", "Dynamic"]
}


# VM 

variable "virtual_machine_size" {
    description =   "Size of the VM"
    type        =   string
    default     =   "Standard_D2s_v3"
}

variable "computer_name" {
    description =   "Computer name"
    type        =   string
    default     =   "Win10"
}

variable "admin_username" {
    description =   "Username to login to the VM"
    type        =   string
    default     =   "win10admin"
}

variable "admin_password" {
    description =   "Password to login to the VM"
    type        =   string
    default     =   "P@$$w0rD2020*"
}

variable "os_disk_caching" {
    default     =       "ReadWrite"
}

variable "os_disk_storage_account_type" {
    default     =       "StandardSSD_LRS"
}

variable "os_disk_size_gb" {
    default     =       128
}

variable "publisher" {
    default         =       "MicrosoftWindowsDesktop"
}

variable "offer" {
    default         =       "Windows-10"
}

variable "sku" {
    default         =       "rs5-pro"
}

variable "vm_image_version" {
    default         =       "latest"
}
