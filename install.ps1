function Create-New-1LevelItem 
{
    Param([string]$Path, [string]$Name)
    
    New-Item –Path $Path –Name $Name
    
    New-ItemProperty -Path "$Path\$Name" -Name "Icon" -Value "$PathForInstall\logo.ico"  -PropertyType "String"
    New-ItemProperty -Path "$Path\$Name" -Name "MUIVerb" -Value "Копировать полный путь"  -PropertyType "String"
    
    $SubMenuElementsName = "Windows-style;Linux-style;Linux-style for WSL"
    New-ItemProperty -Path "$Path\$Name" -Name "SubCommands" -Value $SubMenuElementsName -PropertyType "String"
}

function Create-New-2LevelItem 
{
    Param([string]$Path, [string]$Name, [string]$Command)
    
    New-Item –Path $Path –Name $Name
    New-Item –Path "$Path\$Name" –Name "command"
     
    New-ItemProperty -Path "$Path\$Name\command" -Name "(default)" -Value $Command -PropertyType "String"
}


Write-Output "Hello!"
Write-Output "To the correct installation you need start this script with administrative rights"
$PathForInstall = Read-Host "Enter a path where you want to have a folder with Copy-the-full-path"
$PathForInstall = (Resolve-Path $PathForInstall).Path.TrimEnd("\")

if(!(Test-Path -Path $PathForInstall -PathType Container))
{
    Write-Output "Path `"$PathForInstall`" is uncorrect"
    Write-Output "Stopping install script"

    Exit
}

Write-Output "`nCopy-the-full-path will be install in $PathForInstall`n"

New-Item -Path $PathForInstall -Name "Copy-the-full-path" -ItemType Directory
$PathForInstall = "$PathForInstall\Copy-the-full-path"

# Coping files in folder
Write-Output "Copying main.ps1 in $PathForInstall"
Copy-Item ".\main.ps1" -Destination $PathForInstall

Write-Output "Copying logo.ico in $PathForInstall"
Copy-Item ".\logo.ico" -Destination $PathForInstall

# Creating items in regedit
# Creating main item in contex-menu
$NameOfNewItem = "zCopy-the-full-path"
$RegPathForFiles = "HKLM:\SOFTWARE\Classes\``*\shell\"
$RegPathForFolders = "HKLM:\SOFTWARE\Classes\Directory\shell\"
Create-New-1LevelItem -Path $RegPathForFiles -Name $NameOfNewItem 
Create-New-1LevelItem -Path $RegPathForFolders -Name $NameOfNewItem

# Creating sub-item
$FirstSubItem = "Windows-style"
$SecondSubItem = "Linux-style"
$ThirdSubItem = "Linux-style for WSL"
$RegPathForSubItems = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\"
$CommandTemplate = "cmd /c start /min `"`" powershell -WindowStyle Hidden -ExecutionPolicy Bypass -File $PathForInstall\main.ps1 `"%1`""

Create-New-2LevelItem -Path $RegPathForSubItems -Name $FirstSubItem -Command "$CommandTemplate `"windows`""
Create-New-2LevelItem -Path $RegPathForSubItems -Name $SecondSubItem -Command "$CommandTemplate `"linux`""
Create-New-2LevelItem -Path $RegPathForSubItems -Name $ThirdSubItem -Command "$CommandTemplate `"wsl`""

Write-Output "Installation is done"