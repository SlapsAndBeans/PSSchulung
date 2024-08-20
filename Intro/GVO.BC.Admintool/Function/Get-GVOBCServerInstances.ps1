function Get-GVOBCServerInstances {
    [CmdletBinding()]
    param (
        
    )
    
    begin {
        $myInstances = $()
    }
    
    process {
        $navServIns = Get-NAVServerInstance
        foreach ($i in $navServIns){
            $myInstances += [PSCustomObject]@{
                Name = $i.ServerInstance
                Instanz = $i
            }
        }
    }
    
    end {
        return $myInstances
    }
}