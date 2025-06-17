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

    $ReturnedProperties = @()
    $FileContent = Get-Content "$InputFile" -Raw | ConvertFrom-StringData

    $ReturnedProperties = ForEach ($LineItem in $FileContent) {
        $LineItem = [System.Environment]::ExpandEnvironmentVariables($LineItem)
    }

    return $ReturnedProperties
}
