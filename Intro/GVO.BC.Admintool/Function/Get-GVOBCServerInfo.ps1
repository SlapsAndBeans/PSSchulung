function Get-GVOBCServerInfo {
    [CmdletBinding()]
    param (

        [Parameter()]
        [string]$ServerInstance,
        [Parameter()]
        [string[]] $keysWanted = @(
            'ManagementServicesPort', 'SOAPServicesPort', 'ODataServicesPort', 'DeveloperServicesPort',
            'SnapshotDebuggerServicesPort', 'ClientServicesPort', 'ManagementApiServicesPort',
            'ClientServicesCredentialType', 'Database*', '*Company', '*Language',
            '*Services*Enabled', '*BaseUrl')
    )
    
    begin {

    }
    
    process {
        
        $navServInsArray = Get-NAVServerInstance -ServerInstance $ServerInstance
        $instanceInfoAll = foreach ($i in $navServInsArray){
            [PSCustomObject]@{
                ServerInstance = $i.ServerInstance
                DisplayName = $i.DisplayName
                State = $i.State
                ServiceAccout = $i.ServiceAccout
                Version = $i.Version
                Default = $i.Default
                NAVServInstanceObj = $i
            }
        }

        foreach($i in  $instanceInfoAll){
            $nsc = Get-NAVServerConfiguration -ServerInstance $i.ServerInstance
            $i | Add-Member -MemberType NoteProperty -Name 'NAVServerConfig' -Value $nsc
        
            foreach($j in  $keysWanted){
                $pro = $nsc| Where-Object {$_.Key -like  $j}
                foreach ($pp in $pro){
                    $i | Add-Member -MemberType NoteProperty -Name ([String]$pp.Key) -Value ([String]$pp.Value)
                }
                
            }
    }
    }
    end {
        return($instanceInfoAll)
    }

}
Export-ModuleMember -Function Get-GVOBCServerInfo