
$ErrorActionPreference = 'Stop'

# Create Policy Definition

$policyname     =   'Block MSSQL from Internet'
$description    =   'This policy blocks MSSQL inbound access from Internet'
$policyfile     =   './azure/azure-policies/policyfiles/block1433.json'

try {
    
   $null = New-AzPolicyDefinition `
                -Name $policyname `
                -Description $description `
                -Policy $policyfile `
                -Metadata '{"category":"Network"}' `
                -WarningAction SilentlyContinue

   Write-Host "Policy definition has been created" -ForegroundColor Green 

}
catch {
    Write-Host "Message: $($_.Exception.Message)" -ForegroundColor Red
}

# Create Policy Assignment

$subscription = Get-AzSubscription -SubscriptionName "Vamsi"

$policydef = Get-AzPolicyDefinition -Name $policyname

try{

    $null = New-AzPolicyAssignment `
                -Name $policyname `
                -Description $description `
                -PolicyDefinition $policydef `
                -Scope "/subscriptions/$($subscription.Id)" `
                -WarningAction SilentlyContinue

    Write-Host "Policy assignment has been created" -ForegroundColor Green 

}
catch {
    Write-Host "Message: $($_.Exception.Message)" -ForegroundColor Red
}


