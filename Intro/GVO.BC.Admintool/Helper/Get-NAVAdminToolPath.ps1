function Get-NAVAdminToolPath {
    [CmdletBinding()]
    param (
        [String] $Version
    )
    begin {}
    
    process {
        $toolFiles = @{}
        if ( $Version -ne $null) {
            $installedVersions = Get-BCPath|Where-Object{$_.Version -eq  $Version}
        } else{
            $installedVersions = Get-BCPath
        }
        if ($installedVersions.Length -gt 1){
            $installedVersions = $installedVersions|Out-GridView -Title 'Wähle eine Instanz aus' -OutputMode Single
        }
        Get-BCPath -Version $Version |Get-ChildItem  -File -Filter 'NavAdminTool.ps1' -Recurse -ErrorAction SilentlyContinue| ForEach-Object{if (!$toolFiles.ContainsKey($_.Name)){$toolFiles.Add($_.Name,$_.FullName)}}
        
    }
    
    end {return $toolFiles.Values}
}

Export-ModuleMember -Function Get-NAVAdminToolPath