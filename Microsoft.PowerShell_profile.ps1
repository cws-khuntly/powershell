#
# add path
#
$env:Path += ";$env:UserProfile\Documents\PowerShell\Scripts"

$PSDefaultParameterValues["Out-File:Encoding"] = "utf8"

# https://technet.microsoft.com/en-us/magazine/hh241048.aspx
$MaximumHistoryCount = 10000;

#
# Imports
#
$PSReadLineFile = "$env:UserProfile\Documents\PowerShell\Scripts\PSReadLine.ps1"
$FunctionsFile = "$env:UserProfile\Documents\PowerShell\Scripts\Functions.ps1"
$AliasesFile = "$env:UserProfile\Documents\PowerShell\Scripts\Aliases.ps1"

if (Test-Path($PSReadLineFile)) {
	. $PSReadLineFile
}

if (Test-Path($FunctionsFile)) {
	. $FunctionsFile
}

if (Test-Path($AliasesFile)) {
	. $AliasesFile
}

#
# Chocolatey profile
#
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
	Import-Module "$ChocolateyProfile"
}

#f45873b3-b655-43a6-b217-97c00aa0db58 PowerToys CommandNotFound module
Import-Module -Name Microsoft.WinGet.CommandNotFound
#f45873b3-b655-43a6-b217-97c00aa0db58
