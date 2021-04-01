
# Install Windows Features

$ErrorActionPreference = 'Stop'

Write-Host "Installing Windows Features"

try{

    $null = Install-WindowsFeature -Name AD-Domain-Services,DNS,FileAndStorage-Services -IncludeAllSubFeature -IncludeManagementTools

    Write-Host "ADDS features have been installed"
}
catch {

    Write-Host "Message: $($_.Exception.Message)" -ForegroundColor Red -BackgroundColor DarkBlue
}
#
# Windows PowerShell script for AD DS Deployment
#

Write-Host "Promoting the server as Domain controller"

try {

  $Password = ConvertTo-SecureString -String "Password@123!" -AsPlainText -Force

  Import-Module ADDSDeployment

  $null =   Install-ADDSForest `
                -CreateDnsDelegation:$false `
                -DomainMode "WinThreshold" `
                -DomainName "burugadda.local" `
                -DomainNetbiosName "BURUGADDA" `
                -ForestMode "WinThreshold" `
                -InstallDns:$true `
                -DatabasePath "C:\windows\NTDS" `
                -SysvolPath "C:\windows\SYSVOL" `
                -LogPath "C:\windows\NTDS" `
                -NoRebootOnCompletion:$false `
                -SafeModeAdministratorPassword $Password `
                -SkipPreChecks:$true `
                -Force:$true

  Write-Host "This server has been promoted to a Domain controller, Restarting to apply"

  Restart-Computer

}
catch {
    Write-Host "Message: $($_.Exception.Message)" -ForegroundColor Red -BackgroundColor DarkBlue
}


