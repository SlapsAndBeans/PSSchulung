function Get-BCPath {
    [CmdletBinding()]
    param (
        [String] $Version
    )
    begin {
        $BCPaths = @()
    }
    process {
        $baseKeyPath = "HKLM:\SOFTWARE\Microsoft\Microsoft Dynamics NAV"
        if ($Version.Length -gt 0) {
            $BCPaths += [PSCustomObject]@{
                Version = (Get-Item -Path "$baseKeyPath\$Version\").PSChildName
                Path = (Get-ItemProperty -Path "$baseKeyPath\$Version\Service" -Name Path).Path
            }
        }else{
            
            $RegVersions= Get-ChildItem -Path $baseKeyPath
            foreach ($i in $RegVersions){
                $Path = (Get-ItemProperty -Path "$baseKeyPath\$($i.PSChildName)\Service" -Name Path -ErrorAction SilentlyContinue).Path
                if ($null -eq $Path){
                    $BCPaths += [PSCustomObject]@{
                        Version = $i.PSChildName
                        
                        Path = $Path
                    }
                }
            }
        }

    }
    end {return $BCPaths}
}

