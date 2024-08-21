<#
.SYNOPSIS
    Erstellt eine neue BC Server Instance (ServiceTier)
.DESCRIPTION
    Erstellt eine neue BC Server Instance (ServiceTier). Die angegebenen Ports k�nnen mit einem Offset vor der Erstellung modifiziert werden.
    Nach der Erstellung wird die neue Server Instance gestartet.
.NOTES
    Information or caveats about the function e.g. 'This function is not supported in Linux'
.LINK
    Specify a URI to a help page, this will show when Get-Help -Online is used.
.EXAMPLE
    $newBCServerInfo = Get-GVOBCServerInfo | New-GVOBCServerInstance 'BC' -PortOffset 100 -ServiceAccount User -ServiceAccountCredential $Cred -Verbose
    Nach der Auswahl einer Server Instance wird auf deren Basis eine neue Server Instance erzeugt. Deren ServerInfo wird in der Variablen $newBCServerInfo gespeichert.
#>
function New-GVOBCServerInstance {
    [CmdletBinding()]
    param (
        # ServerInstance
        [Parameter(Mandatory, Position = 0)]
        [String] $ServerInstance,
        # ManagementServicesPort
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [Int] $ManagementServicesPort,
        # SOAPServicesPort
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [Int] $SOAPServicesPort,
        # ODATAServicesPort
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [Int] $ODATAServicesPort,
        # DeveloperServicesPort
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [Int] $DeveloperServicesPort,
        # SnapshotDebuggerServicesPort
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [Int] $SnapshotDebuggerServicesPort,
        # ClientServicesPort
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [Int] $ClientServicesPort,
        # ManagementApiServicesPort
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [Int] $ManagementApiServicesPort,
        # ServiceAccount ('LocalService', 'LocalSystem', 'NetworkService', 'User')
        [Parameter(Mandatory)]
        [ValidateSet('LocalService', 'LocalSystem', 'NetworkService', 'User')]
        [String] $ServiceAccount,
        # ServiceAccountCredential
        [Parameter()]
        [PSCredential] $ServiceAccountCredential,
        # PortOffset
        [Parameter()]  [ValidateScript({ $_ -ge 0 })]
        [Int] $PortOffset,
        # ClientServicesCredentialType ("Windows", "NavUserPassword")
        [Parameter()]
        [ValidateSet("Windows", "NavUserPassword")]
        [String] $ClientServicesCredentialType = "Windows",
        # Start after creating
        [Parameter()]
        [Switch] $StartOnCreate  
    )
    
    begin { 
        $GVOToolSettings = $global:GVOBCToolSettings
        if ($PortOffset -eq 0) {
            Write-Verbose 'nutze Setting defaultPortOffsetNewServer'
            $PortOffset = $GVOToolSettings.defaultPortOffsetNewServer
        }
    }
    
    process {
            . {
                Write-Verbose "PortOffset $PortOffset wird angewendet"
                $ManagementServicesPort += $PortOffset
                $DeveloperServicesPort += $PortOffset
                $ManagementApiServicesPort += $PortOffset
                $ClientServicesPort += $PortOffset
                $ODATAServicesPort += $PortOffset
                $SOAPServicesPort += $PortOffset
                $SnapshotDebuggerServicesPort += $PortOffset

                Write-Verbose "Server-Instance $ServerInstance erstellen ..."
                New-NAVServerInstance `
                    -ManagementServicesPort $ManagementServicesPort `
                    -DeveloperServicesPort $DeveloperServicesPort `
                    -ManagementApiServicesPort $ManagementApiServicesPort `
                    -ClientServicesPort $ClientServicesPort `
                    -SOAPServicesPort $SOAPServicesPort `
                    -ODataServicesPort $ODATAServicesPort `
                    -SnapshotDebuggerServicesPort $SnapshotDebuggerServicesPort `
                    -ClientServicesCredentialType $ClientServicesCredentialType `
                    -ServiceAccount $ServiceAccount `
                    -ServiceAccountCredential $ServiceAccountCredential `
                    -ServerInstance $ServerInstance
        
    
                Write-Verbose "PublicWebBaseUrl auf die neue ServerInstanz konfigureiren"
                Set-NAVServerConfiguration $ServerInstance -KeyName 'PublicWebBaseUrl' -KeyValue "http://localhost:8080/$ServerInstance"
                Set-NAVServerConfiguration $ServerInstance -KeyName 'PublicODataBaseUrl' -KeyValue "http://localhost:7048/$ServerInstance/OData"
                Set-NAVServerConfiguration $ServerInstance -KeyName 'PublicSOAPBaseUrl' -KeyValue "http://localhost:7048/$ServerInstance/WS/"

                
                if ($StartOnCreate){
                    Write-Verbose "Starte Instanz..."
                    Start-NAVServerInstance $ServerInstance
                }
            } | Out-Null
        }
    
        end {
            return Get-GVOBCServerInfo -ServerInstance $ServerInstance

        }
    }
    Export-ModuleMember -Function New-GVOBCServerInstance