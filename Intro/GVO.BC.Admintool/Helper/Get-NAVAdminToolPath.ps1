function Get-NAVAdminToolPath {
    [CmdletBinding()]
    param ()
    
    begin {}
    
    process {
        $toolFiles = @{}
        $installedVersions = Get-BCPath
        if ($installedVersions.Length -gt 1){
            $installedVersions = $installedVersions|Out-GridView -Title 'Wähle eine Instanz aus' -OutputMode Single
        }
        Get-BCPath|Get-ChildItem  -File -Filter 'NavAdminTool.ps1' -Recurse -ErrorAction SilentlyContinue| ForEach-Object{if (!$toolFiles.ContainsKey($_.Name)){$toolFiles.Add($_.Name,$_.FullName)}}
        
    }
    
    end {return $toolFiles.Values}
}