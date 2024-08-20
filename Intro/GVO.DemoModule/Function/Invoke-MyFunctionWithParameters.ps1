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