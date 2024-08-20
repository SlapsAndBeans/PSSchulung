#init data
'Hallo'> C:\Temp\test.txt


# declare variables
$path = 'C:\Temp'

Get-Member -InputObject $path
$path.GetType()
$path.Length



#--------------------------------------------------
# Aufgabe: Verzeichnisse und Dateien anlegen
#--------------------------------------------------
# Step 1:
#   - neues Verzeichnis 'TestData' in $path anlegen
#   - im neuen Verzeichnis weitere Unterverzeichnisse "Verzeichnis1", .. "Verzeichnis3" anlegen
#
#Step 2:
#   - In jedem Verzeichnis sollen mehrere Dateien erstellt werden ( hierbei jeweils 2 )
#       - Dateiname 'Datei<Verzeichnis-Nr.>-<Nr. der Datei>.txt'
#
#
$nameSubDir = 'TestData'
$newSubFolderTemplate = 'Verzeichnis'
$newFileTemplate = 'Datei'
$pathSub = New-Item -Path $path -ItemType Directory -Name $nameSubDir -Force

for ($i =1;$i -le 3;$i++){
    $newSubFolderName = $newSubFolderTemplate + $i
    $newSubFolder = New-Item -Path $pathSub.FullName -ItemType Directory -Name $newSubFolderName -Force
    for ($j =1;$j -le 2;$j++){
        New-Item -Path $newSubFolder.FullName -ItemType File -Name $($newFileTemplate + $i +'-'+$j + '.txt')
    }
}

