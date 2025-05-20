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

    Get-Content "$InputFile" | Select-String -NotMatch "^#|^$|^;" | Select-String "=" | ForEach-Object {
        if (!([string]::IsNullOrWhiteSpace(${_}))) {
            $FileEntryKey, $FileEntryValue = $_ -Split "=", 2

            $PropertyObject = [PSCustomObject]@{
                Name = $FileEntryKey.Trim()
                Value = $ExecutionContext.InvokeCommand.ExpandString($($FileEntryValue -Replace "`"", "").Trim())
            }

			$ReturnedProperties += $PropertyObject
        }
    }

	return $ReturnedProperties
}
