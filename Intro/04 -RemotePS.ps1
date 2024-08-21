

#region WinRM-Dioest konfigurieren
Stop-Service WinRM
Set-Service WinRM -StartupType Automatic
Start-Service WinRM

Set-Item WSMan:\localhost\Client\TrustedHosts -Value "10.11.1.*" -Force
Restart-Service WinRM

#endregion

#region Cred vorbereiten
$passwd = ConvertTo-SecureString 'EiWoha7T@' -AsPlainText -Force
$user = "ah@guatrain.local"
$cred = New-Object System.Management.Automation.PSCredential($user,$passwd)
#endregion



$computers = @()

for ($i = 168; $i -le 179; $i++){
    $computers += [pscustomobject]@{
        Computer = "10.11.1.$($i)"
        Running = (Test-Connection -ComputerName "10.11.1.$($i)" -Quiet -Count 1)
    }
}

$sb = {
    param($p1) Write-Host "Auf Rechner $p1 : $(whoami.exe)"
}

#  $sb1 ={   
#     Remove-Item "C:\Users\guauser\Documents\PS\Intro\IchWarHier.dat"
#     # $f = new-object System.IO.FileStream "C:\Users\guauser\Documents\PS\Intro\IchWarHier.dat", Create, ReadWrite
#     #  $f.SetLength(50MB)
#     #  $f.Close()
#  }

foreach ($comp in $computers){
    Invoke-Command -ComputerName $comp.Computer -ScriptBlock $sb -Authentication NegotiateWithImplicitCredential
}
#C:\Users\guauser\Documents\PS\Intro
# $mySession = New-PSSession -ComputerName '10.11.1.169' -Credential $cred

# Invoke-Command -Session $mySession -ScriptBlock {
#     foreach($i in 1..10){
#         $f = new-object System.IO.FileStream "C:\Users\guauser\Documents\test$i.dat", Create, ReadWrite
#         $f.SetLength(50MB)
#         $f.Close()
#     }
# }


$scriptForComp = (Get-Command .\RemoteScripts\Write-HelloWorld.ps1 | Select-Object -ExpandProperty ScriptBlock).ToString()

$sb = [scriptblock]::Create($scriptForComp)
foreach ($comp in $computers){
    Invoke-Command -ComputerName $comp.Computer -ScriptBlock $sb -Authentication NegotiateWithImplicitCredential
    
}

