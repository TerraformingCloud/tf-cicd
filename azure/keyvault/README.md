# Create a KeyVault in Azure with Terraform

**This module creates a keyvault**

> Note 1: This deployment is not free. If you are not on a free trail, it will incur a very small fee. So, its always a good practice to cleanup everything when you are done with the demo.


## Resources in this module

- A Resource Group
- Key Vault
- KeyVault access policy
- KeyVault Secrets


## After the deployment

- Once the deployment is successful, you can login to the virtual machine. Login to the portal, go to the VM and click on Connect and select SSH.

- Cleanup everything with **$ terraform destroy -auto-approve**
