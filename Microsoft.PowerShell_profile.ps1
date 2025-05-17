#
# add path
#
${env:Path} += ";${env:ProgramFiles}/git/bin"

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

Write-Debug "Start load custom profile"

if (Test-Path -Path "$([Environment]::GetFolderPath(Environment.SpecialFolser.Personal))/PowerShell/" -PathType Container) {
    if (Test-Path -Path "$([Environment]::GetFolderPath(Environment.SpecialFolder.Personal))/PowerShell/Scripts" -PathType Container) {
        $SourceFiles = Get-ChildItem -Path "$([Environment]::GetFolderPath(Environment.SpecialFolder.Personal))/PowerShell/Scripts" -File

        ForEach ($SourceFile in ${SourceFiles}) {
            . ${SourceFile}
        }
    }

    $ChocolateyModulesPath = "$([Environment]::GetFolderPath(Environment.SpecialFolder.Personal))/PowerShell/Modules/Chocolatey.Modules"

    if (Test-Path -Path "${ChocolateyModulesPath}" -PathType Container) {
        $ModuleFiles = Get-ChildItem -Path "${ChocolateyModulesPath}" -File

        ForEach ($ModuleFile in ${ModuleFiles}) {
if (Get-Module -ListAvailable -Name ${ModuleFile} -Verbose:$false) {
                Write-Verbose "Module ${ModuleFile} found, skipping install."

                Continue
            }

            try {
                Write-Verbose "Attemping to install module ${ModuleFile}"

                Import-Module -Name ${ModuleFile} -ErrorAction Stop -Verbose:$false
           }
           catch {
               $ModuleLookup = Find-Module -Name ${ModuleName}

               if (-not "${ModuleLookup}") {
                   Write-Error "Module `"$Module`" not found."

                   continue
               }

               Install-Module -Name ${ModuleName} -Scope AllUsers -Force -AllowClobber
               Import-Module -Name ${ModuleName} -Scope Global -Verbose:$false
            }
        }
    }


    $OpenSSLModulesPath = "$([Environment]::GetFolderPath(Environment.SpecialFolder.Personal))/PowerShell/Modules/OpenSSL.Modules"

    if (Test-Path -Path "${OpenSSLModulesPath}" -PathType Container) {
        $ModuleFiles = Get-ChildItem -Path "${OpenSSLModulesPath}" -File

        ForEach ($ModuleFile in ${ModuleFiles}) {
if (Get-Module -ListAvailable -Name ${ModuleFile} -Verbose:$false) {
                Write-Verbose "Module ${ModuleFile} found, skipping install."

                Continue
            }

            try {
                Write-Verbose "Attemping to install module ${ModuleFile}"

                Import-Module -Name ${ModuleFile} -ErrorAction Stop -Verbose:$false
           }
           catch {
               $ModuleLookup = Find-Module -Name ${ModuleName}

               if (-not "${ModuleLookup}") {
                   Write-Error "Module `"$Module`" not found."

                   continue
               }

               Install-Module -Name ${ModuleName} -Scope AllUsers -Force -AllowClobber
               Import-Module -Name ${ModuleName} -Scope Global -Verbose:$false
            }
        }
    }
}

Write-Debug "End load custom profile"
