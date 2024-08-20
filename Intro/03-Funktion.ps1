function Invoke-MyFunction {
    [CmdletBinding()]
    param ()
    
    begin {}
    
    process {
        Write-Host 'Bla bla bla'
    }
    
    end {}
}

<#
.SYNOPSIS
This function processes an array of names and outputs each name.

.DESCRIPTION
The `Invoke-MyFunctionWithParameters` function takes an array of names as input, processes them, and outputs each name. It supports pipeline input and mandatory parameters.


.EXAMPLE
"Alice", "Bob", "Charlie" | Invoke-MyFunctionWithParameters
Hier könnte ihre Werung stehen!
        - Alice
        - Bob
        - Charlie

    
#>
function Invoke-MyFunctionWithParameters {
    [CmdletBinding()]
    param (
    #An array of names to be processed. This parameter is mandatory and supports pipeline input.
    [Parameter(ValueFromPipeline,ValueFromPipelineByPropertyName,Mandatory)]    
        [string[]] $Name
    )
    
    begin {

        Write-Host "Hier könnte ihre Werung stehen!"
        $NameList=@()
    }
    
    process {
        
        foreach ($n in $Name){
            $NameList+=$n
        }

    }
    
    end {
            foreach ($n in $NameList){
                Write-Host "      - $n"
            }
    }
}


function CreateCustObject {
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

function Invoke-OutCustObject {
    param (
    [Parameter(ValueFromPipeline)]
    [System.Object[]] $myCustObjects
    )
    begin {
        $myCustObjectsInternal = @()
    }
    process{
        foreach ($i in $myCustObjects){
            $myCustObjectsInternal += $i
        }
    }
    end{
        foreach($i in $myCustObjectsInternal){
            Write-Host "Name: $($i.Name) - Active: $($i.Active)"
        }
    }
}




function Invoke-MyFunctionWithParameterSet {
    [CmdletBinding()]
    param (
        [CmdletBinding()]
        [Parameter(Position=0,ValueFromPipeline,ParameterSetName='Set1')]
        [string[]] $Name,
        [Parameter(Position=1,ParameterSetName='Set2')]
        [switch] $UserSelectionDialog
    )
    
    begin {
        Write-Host 'BEGIN'
        $myNameList=@()
    }
    
    process {
        foreach ($i in $Name){
            $myNameList += $i
        }
    }
    
    end {
        Write-Host 'END'
        switch ($PSCmdlet.ParameterSetName) {
            'Set1' {
                #allDone
            }
            'Set2' {
                $myNameList = (Get-ADUser -Filter * | Out-GridView -Title 'Wähle' -OutputMode Multiple).Name
            }
        }
        foreach($i in $myNameList){
            Write-Host "Name: $i"
        }
    }
}

#Invoke-MyFunction;
#Invoke-MyFunctionWithParameters -Name 'Hans';
#Invoke-MyFunctionWithParameters -Name @('Hans','Max','Klaus');
#@('Hans','Max','Klaus') | Invoke-MyFunctionWithParameters

#$AdUsers = Get-ADUser -Filter *
#$AdUsers|Invoke-MyFunctionWithParameters

# $custList = CreateCustObject
# $custList|Invoke-OutCustObject 
# $custList |ConvertTo-Json |Out-File 'myFile.json'

# $custList.Name|Invoke-MyFunctionWithParameterSet
# Invoke-MyFunctionWithParameterSet -UserSelectionDialog