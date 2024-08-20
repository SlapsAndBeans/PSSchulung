function Invoke-CreateCustObject {
    [CmdletBinding()]
    param ()
    begin {
        $AdUsers = Get-ADUser -Filter *

        $custObjList = foreach ($u in $AdUsers){
            [PSCustomObject]@{
                Name = $u.Name
                FirstName = $u.GivenName
                Active = $u.Enabled
            }
        }
    }
    process {}
    end { return $custObjList}
}

New-Alias -Name Invoke-CreateCustObject2 -Value Invoke-CreateCustObject
#Export-ModuleMember -Function Invoke-CreateCustObject
Export-ModuleMember -Function Invoke-CreateCustObject -Alias Invoke-CreateCustObject2

