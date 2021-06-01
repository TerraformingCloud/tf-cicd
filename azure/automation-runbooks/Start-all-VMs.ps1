<#
    .Description
        This runbook starts (Power On) all vms in a given resource group
    .Inputs
        Provide ResourceGroup name and VM names
    .Notes
        Last Edit : June 1, 2021
    
#>


$rgname     =      ""
$vmname     =      ""  # example - "uservm*"

# Login to Azure Subscription

Write-Output "==> Connecting to the Azure Subscription"

try {
    
    $connectionName =   "AzureRunAsConnection"

    # Get the connection "AzureRunAsConnection"

    $auth   =   Get-AutomationConnection -Name $connectionName

    $null   =   Connect-AzAccount `
                    -ServicePrincipal `
                    -Tenant $auth.TenantID `
                    -ApplicationId $auth.ApplicationId `
                    -CertificateThumbprint $auth.CertificateThumbprint

    Write-Output "==> Successfully authenticated to the subscription"

}
catch {
    if(!$auth) 
    {
        $ErrorMessage   =   "Authentication Failed. Connection $connectionName not found."
        throw $ErrorMessage
    } else {
        Write-Error -Message $_.Exception
        throw $_.Exception
    }
}

# Get all VMs and Start them

Write-Output "==> Starting all VMs in the resource group: $rgname"

$VMs = Get-AzVM -ResourceGroupName $rgname -Name $vmname

$VMs | Start-AzVM -WarningAction Ignore

Start-Sleep -Seconds 90

Get-AzVM -ResourceGroupName $rgname -Name $vmname -Status | Select-Object Name, ResourceGroupName, PowerState

Write-Output "==> VMs have been started"