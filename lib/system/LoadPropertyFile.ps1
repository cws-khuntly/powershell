<#
#==============================================================================
#
#          FILE:  install.ps1
#         USAGE:  powershell -NoExit -File "install.ps1"
#   DESCRIPTION:  Installs the Chocolatey Package Manager
#
#       OPTIONS:  ---
#  REQUIREMENTS:  ---
#          BUGS:  ---
#         NOTES:  Called as a part of the PowerShell script "chocolatey.ps1"
#        AUTHOR:  Kevin Huntly <kmhuntly@gmail.com>
#       COMPANY:  ---
#       VERSION:  1.0
#       CREATED:  ---
#      REVISION:  ---
#
#==============================================================================
#>

Function Get-Properties() {
    param (
        [Parameter(Mandatory=$true)]
        [string] $InputFile
    )
    Write-Output "InputFile: $InputFile"
    if (Test-Path Variable:ReturnedProperties) { Remove-Variable -Name ReturnedProperties }
    if (Test-Path Variable:PropertyTemplate) { Remove-Variable -Name PropertyTemplate }
    if (Test-Path Variable:FileContent) { Remove-Variable -Name FileContent }
    if (Test-Path Variable:LineItem) { Remove-Variable -Name LineItem }

    $ReturnedProperties = @()
    $PropertyTemplate = Get-Content "$InputFile" -Raw | ConvertFrom-StringData
    Write-Output "PropertyTemplate: $PropertyTemplate"
    $ReplaceText = $PropertyTemplate -Replace "`"", ""
    Write-Output "ReplaceText: $ReplaceText"
    $ReturnedProperties = [System.Environment]::ExpandEnvironmentVariables($ReplaceText)

    return $ReturnedProperties
}
