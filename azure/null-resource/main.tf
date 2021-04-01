#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*
# Execute scripts on local machine using Null resource and Provisioners
#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*

resource "null_resource" "ps" {
    
    # Single Line command

    provisioner "local-exec" {
        command         =   "Write-Host \"Hello ${var.user}\"" 
        interpreter     =   ["pwsh", "-Command"]
    }

     # Multi Line command

    provisioner "local-exec" {
        command         = <<EOT
          Write-Host  "Hello ${var.user}" 
          Write-Host  "This is executed by Terraform" 
          Write-Host  "Goodbye" 
        EOT
        interpreter     =   ["pwsh", "-Command"]
    }

    provisioner "local-exec" {
        command         =    "echo Hello, ${var.user}"
    }

}

variable "user" {
    default =   "Vamsi"
}