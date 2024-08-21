#-------------------------------------------------
# 03-ServerErstellen
# ein reines Arbeitsscript
#-------------------------------------------------

Import-Module .\GVO.BC.Admintool\ -Forc
. (Get-NAVAdminToolPath -Version 240)

# settings
$GVOToolSettings = $global:GVOBCToolSettings
 
# Server auswählen
$bcServerInfos = Get-GVOBCServerInfo
$selbcServerInfo = $bcServerInfos | Out-GridView -Title "BC Server Info wählen" -OutputMode Single

# Credentials anlegen
$passwd = ConvertTo-SecureString 'EiWoha7T@' -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential('guatrain\BCServerAccount',$passwd)

# Name der nueen Server-Instanz abfragen
$defaultServerName = $GVOToolSettings.defaultServerNameNewServer
$serverName = Read-Host "ServerInstanceName [$defaultServerName)] mit <Enter> bestätigen oder neuinen Namen angeben"
$serverName = ($defaultServerName,$serverName)[[bool]$serverName]

# Neue Server-Instanz anlegen
$newServerInstance =  $selbcServerInfo | New-GVOBCServerInstance -ServerInstance $serverName -ServiceAccount User -ServiceAccountCredential $cred -Verbose
if ($newServerInstance.ServerInstance -eq $null){
    $newServerInstance = Get-GVOBCServerInfo -ServerInstance 'BCNew'
}
# Neue WebServer-Instanz anlegen
New-NAVWebServerInstance -WebServerInstance "BCNew" `
    -Server 'localhost' `
    -ServerInstance $newServerInstance.ServerInstance `
    -SiteDeploymentType SubSite `
    -ClientServicesPort $newServerInstance.ClientServicesPort `
    -ClientServicesCredentialType $newServerInstance.ClientServicesCredentialType `
    -ManagementServicesPort $newServerInstance.ManagementServicesPort