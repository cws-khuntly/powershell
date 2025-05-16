#
# add path
#
$PSDefaultParameterValues["Out-File:Encoding"] = "utf8"

# https://technet.microsoft.com/en-us/magazine/hh241048.aspx
$MaximumHistoryCount = 10000;

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

if (Test-Path -Path "$([Environment]::GetFolderPath("Personal"))/PowerShell/)" -PathType Container) {
    if (Test-Path -Path "$([Environment]::GetFolderPath("Personal"))/PowerShell/Scripts)" -PathType Container) {
        $SourceFiles = Get-ChildItem -Path "$([Environment]::GetFolderPath("Personal"))/PowerShell/Scripts)" -File

        ForEach ($SourceFile in ${SourceFiles}) {
            . ${SourceFiles}
        }
    }

    $ChocolateyModulesPath = "$([Environment]::GetFolderPath("Personal"))/PowerShell/Modules/Chocolatey.Modules"
    $OpenSSLModulesPath = "$([Environment]::GetFolderPath("Personal"))/PowerShell/Modules/Chocolatey.Modules"

    if (Test-Path -Path "${ChocolateyModulesPath}" -PathType Container) {
        Import-Module -Name "${ChocolateyModulesPath}" -Verbose
    }

    if (Test-Path -Path "${OpenSSLModulesPath}" -PathType Container) {
        Import-Module -Name "${OpenSSLModulesPath}" -Verbose
    }
}
