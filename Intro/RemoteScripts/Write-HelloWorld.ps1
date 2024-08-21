$ipAddress = (Get-NetIPAddress `
        -InterfaceAlias (Get-NetAdapter | Where-Object {!$_.Virtual}).Name `
        -PrefixOrigin DHCP).IPv4Address

Write-Host "Hello World! $(whoami) on IP $($ipAddress -join ' or ') " -ForegroundColor Green