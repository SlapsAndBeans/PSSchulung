Set-Location $PSScriptRoot
New-ModuleManifest -Path "..\GVO.BC.Admintool.psd1" `
    -RootModule GVO.BC.Admintool.psm1 `
    -ModuleVersion "1.0.0" `
    -Copyright "GVO" `
    -Author "Georg Vogl" `
    -CompanyName "GVO" `
    -Description "Komfortfunktionen zur BC/NAV-Verwaltung"