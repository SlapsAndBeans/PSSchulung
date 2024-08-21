<#
.SYNOPSIS
Einstellungen laden

.DESCRIPTION
Mit dieser Funktion lade ich alle möglichen Einstellungen aus einer config.json
Wenn ein Fehler beim laden passiert, nutze ich Default settings


.EXAMPLE
LoadSettings;
#>
function LoadSettings {
    [CmdletBinding()]
    param ()
    process{

        try {
            Write-Verbose 'Lese Configuration'
            $global:GVOBCToolSettings = Get-Content -Raw -Path "$PSScriptRoot\..\config.json" | ConvertFrom-Json
        }
        catch{
            # setze default settings
            $global:GVOBCToolSettings =[PSCustomObject]@{
                [string] $defaultServerNameNewServer ='BC'
            }
        }
    }

}