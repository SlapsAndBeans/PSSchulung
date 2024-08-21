$ListofFolders = @('Function','Helper','Blabla')
$ListofFolders|ForEach-Object{Join-Path -Path $PSScriptRoot -ChildPath "\$($_)\"|Get-ChildItem  -File -Filter '*.ps1' -Recurse -ErrorAction SilentlyContinue | ForEach-Object{. $_.FullName}}

LoadSettings -Verbose