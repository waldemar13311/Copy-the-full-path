$PathForUninstall = Read-Host "To uninstall Copy-the-full-path enter a directory where it has installed"
$PathForUninstall = (Resolve-Path $PathForUninstall).Path.TrimEnd("\")

if (!(Test-Path -Path $PathForUninstall -PathType Container))
{
    Write-Output "Path `"$PathForUninstall`" is uncorrect"
    Write-Output "Stopping uninstall script"

    Exit
}


$LastFolderName = $PathForUninstall.Substring($PathForUninstall.LastIndexOf("\") + 1)
$StandartInstallationNameFolder = "Copy-the-full-path"
if(!($LastFolderName -eq $StandartInstallationNameFolder))
{
    Write-Output "`"$PathForUninstall`" is not Copy-the-full-path path"
    Write-Output "Stopping uninstall script"

    Exit
}

Write-Output "Deleting items in registry"

$RegPathForFiles = "HKLM:\SOFTWARE\Classes\``*\shell\zCopy-the-full-path"
$RegPathForFolders = "HKLM:\SOFTWARE\Classes\Directory\shell\zCopy-the-full-path"
Remove-Item –Path $RegPathForFiles –Recurse
Remove-Item –Path $RegPathForFolders –Recurse

$FirstSubItem = "Windows-style"
$SecondSubItem = "Linux-style"
$ThirdSubItem = "Linux-style for WSL"
$RegPathForSubItems = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell"

Remove-Item –Path "$RegPathForSubItems\$FirstSubItem" –Recurse
Remove-Item –Path "$RegPathForSubItems\$SecondSubItem" –Recurse
Remove-Item –Path "$RegPathForSubItems\$ThirdSubItem" –Recurse

Write-Output "Deleting Copy-the-full-path folder"
Remove-Item -Path $PathForUninstall -Recurse -Force

Write-Output "Deleting is done"