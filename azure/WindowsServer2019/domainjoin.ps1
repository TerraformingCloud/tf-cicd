# Set DNS Client Server Address to connect to the domain

$ErrorActionPreference = 'Stop'

Write-Host "Setting the DNS Client server address"

$ii = (Get-NetIPAddress -InterfaceAlias Ethernet -AddressFamily IPV4).InterfaceIndex

Set-DnsClientServerAddress -InterfaceIndex $ii -ServerAddresses "10.0.0.4"

Write-Host "Adding the computer to the domain"

try {

    # Define Credentials
    [string]$userName = "burugada\winserveradmin"
    [string]$userPassword = 'P@$$w0rD2020*'

    # Crete credential Object
    [SecureString]$secureString = $userPassword | ConvertTo-SecureString -AsPlainText -Force 
    [PSCredential]$domaincreds = New-Object System.Management.Automation.PSCredential -ArgumentList $userName, $secureString

    $null = Add-Computer -DomainName "burugadda.local" -Credential $domaincreds

    Write-Host "Computer has joined the domain"

    # Add Domain Users to Remote Desktop Users group

    Write-Host "Adding Domain users to RDU Group"

    Add-LocalGroupMember -Group "Remote Desktop Users" -Member "burugadda.local\Domain Users"

}
catch {
    Write-Host "Message: $($_.Exception.Message)" 
}





