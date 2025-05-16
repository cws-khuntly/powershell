<#
#==============================================================================
#
#          FILE:  chocolatey.ps1
#         USAGE:  powershell -NoExit -File "chocolatey.ps1"
#   DESCRIPTION:  Installs the Chocolatey Package Manager and desired packages
#
#       OPTIONS:  ---
#  REQUIREMENTS:  ---
#          BUGS:  ---
#         NOTES:  ---
#        AUTHOR:  Kevin Huntly <kmhuntly@gmail.com>
#       COMPANY:  ---
#       VERSION:  1.0
#       CREATED:  ---
#      REVISION:  ---
#
#==============================================================================
#>

Set-ExecutionPolicy Bypass -Scope Process -Force;

$ScriptEntries = @(
    "$env:UserProfile\OneDrive\Documents\PowerShell\Scripts\install.ps1"
    "$env:UserProfile\OneDrive\Documents\PowerShell\Scripts\apps.ps1"
)
foreach ($ScriptEntry in $ScriptEntries) {
    Start-Process -FilePath "$env:SystemRoot\system32\WindowsPowerShell\v1.0\powershell.exe" -ArgumentList "-command & '$ScriptEntry'" -Wait
}
