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

#
# sysinternals module
#
Install-Module -Name SysInternals
Import-Module -Name SysInternals

#
# VMware PowerCLI
#
Install-Module -Name VMware.PowerCLI
Import-Module -Name VMware.PowerCLI

#
# OpenSSL
#
Install-Module -Name OpenSSL
Import-Module -Name OpenSSL

#
# windows update
#
Install-Module -Name PSWindowsUpdate
Import-Module -Name PSWindowsUpdate

#
# winget
#
Install-Module -Name Microsoft.WinGet.Client
Install-Module -Name Microsoft.WinGet.CommandNotFound
Import-Module -Name Microsoft.WinGet.Client
Import-Module -Name Microsoft.WinGet.CommandNotFound

if (Test-Path -Path "$([Environment]::GetFolderPath("Personal"))/PowerShell/" -PathType Container) {
    if (Test-Path -Path "$([Environment]::GetFolderPath("Personal"))/PowerShell/lib" -PathType Container) {
        $LoadPropertyHandler = "$([Environment]::GetFolderPath("Personal"))/PowerShell/lib/system/LoadPropertyFile.ps1"
        $Logger = "$([Environment]::GetFolderPath("Personal"))/PowerShell/lib/system/logger.ps1"

        if (Test-Path -Path "${LoadPropertyHandler}" -PathType Leaf) {
            . "${LoadPropertyHandler}"
        }

        if (Test-Path -Path "${Logger}" -PathType Leaf) {
            . "${Logger}"
        }
    }

    $SourceFiles = Get-ChildItem -Path "$([Environment]::GetFolderPath("Personal"))/PowerShell/lib/system" -File
    $SourceFiles += Get-ChildItem -Path "$([Environment]::GetFolderPath("Personal"))/PowerShell/lib/profile" -File

    if (!([string]::IsNullOrEmpty("${LoggingLoaded}")) -and (!([string]::IsNullOrEmpty("${IsDebugEnabled}"))) -and ("${isDebugEnabled}" -Match "true")) {
        writeLogEntry "FILE" "DEBUG" "$([System.Diagnostics.Process]::GetCurrentProcess().Id)" "$(Split-Path ${MyInvocation.PSCommandPath} -Leaf)" "${MyInvocation.ScriptLineNumber}" "ProfileLoad" "SourceFiles -> ${SourceFiles}";
    }

    ForEach ($SourceFile in ${SourceFiles}) {
        if (!([string]::IsNullOrEmpty("${LoggingLoaded}")) -and (!([string]::IsNullOrEmpty("${IsDebugEnabled}"))) -and ("${isDebugEnabled}" -Match "true")) {
            writeLogEntry "FILE" "DEBUG" "$([System.Diagnostics.Process]::GetCurrentProcess().Id)" "$(Split-Path ${MyInvocation.PSCommandPath} -Leaf)" "${MyInvocation.ScriptLineNumber}" "ProfileLoad" "SourceFile -> ${SourceFile}";
        }

        if ("${SourceFile}" -Match "logger.ps1") {
            Continue
        }

        if (!([string]::IsNullOrEmpty("${LoggingLoaded}")) -and (!([string]::IsNullOrEmpty("${IsDebugEnabled}"))) -and ("${isDebugEnabled}" -Match "true")) {
            writeLogEntry "FILE" "DEBUG" "$([System.Diagnostics.Process]::GetCurrentProcess().Id)" "$(Split-Path ${MyInvocation.PSCommandPath} -Leaf)" "${MyInvocation.ScriptLineNumber}" "ProfileLoad" "EXEC: . ${SourceFile}";
        }

        . ${SourceFile}
    }

    $LoadModulesList = "$([Environment]::GetFolderPath("Personal"))/PowerShell/config/profile/LoadModules.properties"

    if (!([string]::IsNullOrEmpty("${LoggingLoaded}")) -and (!([string]::IsNullOrEmpty("${IsDebugEnabled}"))) -and ("${isDebugEnabled}" -Match "true")) {
        writeLogEntry "FILE" "DEBUG" "$([System.Diagnostics.Process]::GetCurrentProcess().Id)" "$(Split-Path ${MyInvocation.PSCommandPath} -Leaf)" "${MyInvocation.ScriptLineNumber}" "ProfileLoad" "EXEC: . ${SourceFile}";
    }

    if (Test-Path -Path "${LoadModulesList}" -PathType Leaf) {
        Get-Content -Path "${LoadModulesList}" | ForEach-Object {
            if (!($_ -Match "#")) {
                $ModuleName = $_
                $ModulePath = "$([Environment]::GetFolderPath("Personal"))/PowerShell/Modules/${ModuleName}"

                if (!([string]::IsNullOrEmpty("${LoggingLoaded}")) -and (!([string]::IsNullOrEmpty("${IsDebugEnabled}"))) -and ("${isDebugEnabled}" -Match "true")) {
                    writeLogEntry "FILE" "DEBUG" "$([System.Diagnostics.Process]::GetCurrentProcess().Id)" "$(Split-Path ${MyInvocation.PSCommandPath} -Leaf)" "${MyInvocation.ScriptLineNumber}" "ProfileLoad" "ModuleName -> ${ModuleName}";
                    writeLogEntry "FILE" "DEBUG" "$([System.Diagnostics.Process]::GetCurrentProcess().Id)" "$(Split-Path ${MyInvocation.PSCommandPath} -Leaf)" "${MyInvocation.ScriptLineNumber}" "ProfileLoad" "ModulePath -> ${ModulePath}";
                }

                if (Test-Path -Path "${ModulePath}" -PathType Container) {
                    $ModuleFiles = Get-ChildItem -Path "${ModulePath}" -File

                    if (!([string]::IsNullOrEmpty("${LoggingLoaded}")) -and (!([string]::IsNullOrEmpty("${IsDebugEnabled}"))) -and ("${isDebugEnabled}" -Match "true")) {
                        writeLogEntry "FILE" "DEBUG" "$([System.Diagnostics.Process]::GetCurrentProcess().Id)" "$(Split-Path ${MyInvocation.PSCommandPath} -Leaf)" "${MyInvocation.ScriptLineNumber}" "ProfileLoad" "ModuleFiles -> ${ModuleFiles}";
                    }

                    ForEach ($ModuleFile in ${ModuleFiles}) {
                        if (Get-Module -ListAvailable -Name ${ModuleFile} -Verbose:$false) {
                            if (!([string]::IsNullOrEmpty("${LoggingLoaded}"))) {
                                writeLogEntry "FILE" "INFO" "$([System.Diagnostics.Process]::GetCurrentProcess().Id)" "$(Split-Path ${MyInvocation.PSCommandPath} -Leaf)" "${MyInvocation.ScriptLineNumber}" "ProfileLoad" "Module ${ModuleFile} found in environment, not loading";
                            }

                            Continue
                        }

                        try {
                            if (!([string]::IsNullOrEmpty("${LoggingLoaded}")) -and (!([string]::IsNullOrEmpty("${IsDebugEnabled}"))) -and ("${isDebugEnabled}" -Match "true")) {
                                writeLogEntry "FILE" "DEBUG" "$([System.Diagnostics.Process]::GetCurrentProcess().Id)" "$(Split-Path ${MyInvocation.PSCommandPath} -Leaf)" "${MyInvocation.ScriptLineNumber}" "ProfileLoad" "Loading module ${ModuleFile}";
                                writeLogEntry "FILE" "DEBUG" "$([System.Diagnostics.Process]::GetCurrentProcess().Id)" "$(Split-Path ${MyInvocation.PSCommandPath} -Leaf)" "${MyInvocation.ScriptLineNumber}" "ProfileLoad" "EXEC: Import-Module -Name ${ModuleFile} -ErrorAction Stop -Verbose:$false";
                            }

                            Import-Module -Name ${ModuleFile} -ErrorAction Stop -Verbose:$false
                        }
                        catch {
                            $ModuleLookup = Find-Module -Name ${ModuleName}

                            if (!([string]::IsNullOrEmpty("${LoggingLoaded}")) -and (!([string]::IsNullOrEmpty("${IsDebugEnabled}"))) -and ("${isDebugEnabled}" -Match "true")) {
                                writeLogEntry "FILE" "DEBUG" "$([System.Diagnostics.Process]::GetCurrentProcess().Id)" "$(Split-Path ${MyInvocation.PSCommandPath} -Leaf)" "${MyInvocation.ScriptLineNumber}" "ProfileLoad" "ModuleLookup -> ${ModuleLookup}";
                            }

                            if ([string]::IsNullOrEmpty("${ModuleLookup}")) {
                                if (!([string]::IsNullOrEmpty("${LoggingLoaded}"))) {
                                    writeLogEntry "FILE" "ERROR" "$([System.Diagnostics.Process]::GetCurrentProcess().Id)" "$(Split-Path ${MyInvocation.PSCommandPath} -Leaf)" "${MyInvocation.ScriptLineNumber}" "ProfileLoad" "Module ${ModuleFile} failed to load.";
                                    writeLogEntry "CONSOLE" "STDERR" "Module ${ModuleFile} failed to load.";
                                }

                                Continue
                            }

                            if (!([string]::IsNullOrEmpty("${LoggingLoaded}")) -and (!([string]::IsNullOrEmpty("${IsDebugEnabled}"))) -and ("${isDebugEnabled}" -Match "true")) {
                                writeLogEntry "FILE" "DEBUG" "$([System.Diagnostics.Process]::GetCurrentProcess().Id)" "$(Split-Path ${MyInvocation.PSCommandPath} -Leaf)" "${MyInvocation.ScriptLineNumber}" "ProfileLoad" "EXEC: Install-Module -Name ${ModuleName} -Scope AllUsers -Force -AllowClobber";
                                writeLogEntry "FILE" "DEBUG" "$([System.Diagnostics.Process]::GetCurrentProcess().Id)" "$(Split-Path ${MyInvocation.PSCommandPath} -Leaf)" "${MyInvocation.ScriptLineNumber}" "ProfileLoad" "EXEC: Import-Module -Name ${ModuleName} -Scope Global -Verbose:$false";
                            }

                            Install-Module -Name ${ModuleName} -Scope AllUsers -Force -AllowClobber
                            Import-Module -Name ${ModuleName} -Scope Global -Verbose:$false
                        }
                    }
                }
            }
        }
    }
}
