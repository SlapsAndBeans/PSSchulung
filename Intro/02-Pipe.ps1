$basePath = 'c:\temp\TestData'

Get-ChildItem -Path $basePath -Recurse 

Get-ChildItem -Path $basePath -Recurse | Get-Member -MemberType Properties

Get-ChildItem -Path $basePath -Recurse | Sort-Object -Property BaseName -Descending
Get-ChildItem -Path $basePath -Recurse | Sort-Object -Property BaseName -Descending | Select-Object BaseName,Extension



Get-ChildItem -Path $basePath -Recurse `| 
    Sort-Object -Property BaseName -Descending| `
    Format-Table -Property BaseName,Extension

$selFiles = Get-ChildItem -Path $basePath -Recurse -File |
    Sort-Object -Property BaseName -Descending| 
    Out-GridView -Title 'Wähle' -OutputMode Multiple

$selFiles |ForEach-Object {Add-Content -Path $_.FullName -Value 'Hier könnte ihre Werbung stehen' }



Get-ChildItem -Path $basePath -Recurse -File| 
    here-Object -FilterScript {($_.Length -gt 0) -and ($_.Name -like '*.2.*')}|
    Select-Object Name


Get-ChildItem -Path $basePath -Recurse |
    Group-Object -Property Directory 

Get-ADGroup -Filter 'Name -like "*Users"'
Get-ADGroup -Filter 'Name -like "*Users"'|
    Get-ADGroupMember |
    Sort-Object -Unique|
    Format-Table



Get-ADGroup -Filter 'Name -like "*Users"'|
    Get-ADGroupMember |
    Sort-Object -Unique|
    Get-ADUser|
    Format-Table


$x = Get-ADGroup -Filter 'Name -like "*Users"'|
    Get-ADGroupMember |
    Sort-Object -Unique



Get-ADGroup -Filter 'Name -like "*Users"'|
    Get-ADGroupMember |
    Sort-Object -Unique | 
    ForEach-Object {Get-ADUser -Filter "SID -eq '$($_.SID)'"}|
    Format-Table

Get-ADGroup -Filter 'Name -like "*Users"'|
    Get-ADGroupMember |
    Sort-Object -Unique | 
    ForEach-Object {Get-ADUser -Filter "SID -eq '$_.SID'"}|
    Format-Table


Get-ADGroup -Filter *| 
    Where-Object -FilterScript {$_.Name -Like '*users'} | 
    ForEach-Object {Get-ADGroupMember -Identity $_} | 
    ForEach-Object {Get-ADUser -Identity $_} | Out-GridView

$a = Get-ADGroup -Filter *                                          # Stufe 1
$b = $a| Where-Object -FilterScript {$_.Name -Like '*users'}        # Stufe 2
$c = $b| ForEach-Object {Get-ADGroupMember -Identity $_}            # Stufe 3
$d = $c|ForEach-Object {Get-ADUser -Identity $_}                    # Stufe 4
$d |Out-GridView