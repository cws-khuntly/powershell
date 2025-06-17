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

$PSDefaultParameterValues["Out-File:Encoding"] = "utf8"

$SystemLibsPath = "$([Environment]::GetFolderPath('Personal'))/PowerShell/lib/system"
$ProfileLibsPath = "$([Environment]::GetFolderPath('Personal'))/PowerShell/lib/profile"
$SystemConfigPath = "$([Environment]::GetFolderPath('Personal'))/PowerShell/config/system"
$ProfileConfigPath = "$([Environment]::GetFolderPath('Personal'))/PowerShell/config/profile"
$LoggingProperties = "$SystemConfigPath/logging.properties"
$LoadModulesList = "$ProfileConfigPath/LoadModules.properties"

#
# Chocolatey profile
#
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
    Import-Module "$ChocolateyProfile"
}

if (Test-Path -Path "$([Environment]::GetFolderPath('Personal'))/PowerShell/lib" -PathType Container) {
    $LoadPropertyHandler = "$([Environment]::GetFolderPath('Personal'))/PowerShell/lib/system/LoadPropertyFile.ps1"
    $Logger = "$([Environment]::GetFolderPath('Personal'))/PowerShell/lib/system/logging.ps1"

    if (Test-Path -Path "$LoadPropertyHandler" -PathType Leaf) {
        . "$LoadPropertyHandler"
    }

    if (Test-Path -Path "$Logger" -PathType Leaf) {
        . "$Logger"
    }
}

if (Test-Path -Path "$SystemLibsPath" -PathType Container) { $SourceFiles = Get-ChildItem -Path "$SystemLibsPath/*" -Include "*.ps1" }
if (Test-Path -Path "$ProfileLibsPath" -PathType Container) { $SourceFiles += Get-ChildItem -Path "$ProfileLibsPath/*" -Include "*.ps1" }

if (!([string]::IsNullOrEmpty("$LoggingLoaded")) -and (!([string]::IsNullOrEmpty("$IsDebugEnabled"))) -and ("$IsDebugEnabled" -Match "true")) {
    writeLogEntry "FILE" "DEBUG" "$([System.Diagnostics.Process]::GetCurrentProcess().Id)" "$(Split-Path $MyInvocation.PSCommandPath -Leaf)" "$MyInvocation.ScriptLineNumber" "ProfileLoad" "SourceFiles -> $SourceFiles";
}

if (!([string]::IsNullOrEmpty("$SourceFiles"))) {
    ForEach ($SourceFile in $SourceFiles) {
        if (!([string]::IsNullOrEmpty("$LoggingLoaded")) -and (!([string]::IsNullOrEmpty("$IsDebugEnabled"))) -and ("$IsDebugEnabled" -Match "true")) {
            writeLogEntry "FILE" "DEBUG" "$([System.Diagnostics.Process]::GetCurrentProcess().Id)" "$(Split-Path $MyInvocation.PSCommandPath -Leaf)" "$MyInvocation.ScriptLineNumber" "ProfileLoad" "SourceFile -> $SourceFile";
        }

        if ("$SourceFile" -Match "logging.ps1") {
            Continue
        }

        if (!([string]::IsNullOrEmpty("$LoggingLoaded")) -and (!([string]::IsNullOrEmpty("$IsDebugEnabled"))) -and ("$IsDebugEnabled" -Match "true")) {
            writeLogEntry "FILE" "DEBUG" "$([System.Diagnostics.Process]::GetCurrentProcess().Id)" "$(Split-Path $MyInvocation.PSCommandPath -Leaf)" "$MyInvocation.ScriptLineNumber" "ProfileLoad" "EXEC: . $SourceFile";
        }

        . "$SourceFile"
    }
}

if (!([string]::IsNullOrEmpty("$LoggingLoaded")) -and (!([string]::IsNullOrEmpty("$IsDebugEnabled"))) -and ("$IsDebugEnabled" -Match "true")) {
    writeLogEntry "FILE" "DEBUG" "$([System.Diagnostics.Process]::GetCurrentProcess().Id)" "$(Split-Path $MyInvocation.PSCommandPath -Leaf)" "$MyInvocation.ScriptLineNumber" "ProfileLoad" "LoadModulesList -> $LoadModulesList";
}

if (Test-Path -Path "$LoadModulesList" -PathType Leaf) {
    Get-Content -Path "$LoadModulesList" | ForEach-Object {
        if (-not ([string]::IsNullOrEmpty($_)) -and -not ($_ -Match "^(#|$|;)")) {
            $ModuleName = "$_"

			if (!([string]::IsNullOrEmpty("$LoggingLoaded")) -and (!([string]::IsNullOrEmpty("$IsDebugEnabled"))) -and ("$IsDebugEnabled" -Match "true")) {
				writeLogEntry "FILE" "DEBUG" "$([System.Diagnostics.Process]::GetCurrentProcess().Id)" "$(Split-Path $MyInvocation.PSCommandPath -Leaf)" "$MyInvocation.ScriptLineNumber" "ProfileLoad" "ModuleName -> $ModuleName";
			}

			#
			# check if the module is installed
			#
			$ModuleIsInstalled = Get-Module -ListAvailable -Verbose:$false | Where-Object { $_.Name -eq $ModuleName }

			if (!([string]::IsNullOrEmpty("$LoggingLoaded")) -and (!([string]::IsNullOrEmpty("${IsDebugEnabled}"))) -and ("${isDebugEnabled}" -Match "true")) {
				writeLogEntry "FILE" "DEBUG" "$([System.Diagnostics.Process]::GetCurrentProcess().Id)" "$(Split-Path $MyInvocation.PSCommandPath -Leaf)" "$MyInvocation.ScriptLineNumber" "ProfileLoad" "ModuleIsInstalled -> $ModuleIsInstalled";
			}

			if ([string]::IsNullOrEmpty("$ModuleIsInstalled")) {
				# module is not installed, install it
				if (!([string]::IsNullOrEmpty("$LoggingLoaded")) -and (!([string]::IsNullOrEmpty("${IsDebugEnabled}"))) -and ("${isDebugEnabled}" -Match "true")) {
					writeLogEntry "FILE" "DEBUG" "$([System.Diagnostics.Process]::GetCurrentProcess().Id)" "$(Split-Path $MyInvocation.PSCommandPath -Leaf)" "$MyInvocation.ScriptLineNumber" "ProfileLoad" "EXEC: Install-Module -Name $ModuleName -Scope CurrentUser -Force -AllowClobber";
				}

				Install-Module -Name "$ModuleName" -Scope CurrentUser -Force -AllowClobber
				$ExitCode = $LastExitCode

				if ($ExitCode -ne 0) {
					if (!([string]::IsNullOrEmpty("$LoggingLoaded"))) {
						writeLogEntry "FILE" "ERROR" "$([System.Diagnostics.Process]::GetCurrentProcess().Id)" "$(Split-Path $MyInvocation.PSCommandPath -Leaf)" "$MyInvocation.ScriptLineNumber" "ProfileLoad" "Failed to install module $ModuleName with return code $ExitCode";
						writeLogEntry "CONSOLE" "STDERR" "$([System.Diagnostics.Process]::GetCurrentProcess().Id)" "$(Split-Path $MyInvocation.PSCommandPath -Leaf)" "$MyInvocation.ScriptLineNumber" "ProfileLoad" "Failed to install module $ModuleName with return code $ExitCode";
					}
				} else {
					# module is installed, import it
					if (!([string]::IsNullOrEmpty("$LoggingLoaded")) -and (!([string]::IsNullOrEmpty("${IsDebugEnabled}"))) -and ("${isDebugEnabled}" -Match "true")) {
						writeLogEntry "FILE" "DEBUG" "$([System.Diagnostics.Process]::GetCurrentProcess().Id)" "$(Split-Path $MyInvocation.PSCommandPath -Leaf)" "$MyInvocation.ScriptLineNumber" "ProfileLoad" "EXEC: Install-Module -Name $ModuleName -Scope CurrentUser -Force -AllowClobber";
					}

					Import-Module -Name "$ModuleName" -Scope Global -Verbose:$false
					$ExitCode = $LastExitCode

					if ($ExitCode -ne 0) {
						if (!([string]::IsNullOrEmpty("$LoggingLoaded"))) {
							writeLogEntry "FILE" "ERROR" "$([System.Diagnostics.Process]::GetCurrentProcess().Id)" "$(Split-Path $MyInvocation.PSCommandPath -Leaf)" "$MyInvocation.ScriptLineNumber" "ProfileLoad" "Failed to install module $ModuleName with return code $ExitCode";
							writeLogEntry "CONSOLE" "STDERR" "$([System.Diagnostics.Process]::GetCurrentProcess().Id)" "$(Split-Path $MyInvocation.PSCommandPath -Leaf)" "$MyInvocation.ScriptLineNumber" "ProfileLoad" "Failed to install module $ModuleName with return code $ExitCode";
						}
					}
				}
			} else {
				# module is installed, import it
				if (!([string]::IsNullOrEmpty("$LoggingLoaded")) -and (!([string]::IsNullOrEmpty("${IsDebugEnabled}"))) -and ("${isDebugEnabled}" -Match "true")) {
					writeLogEntry "FILE" "DEBUG" "$([System.Diagnostics.Process]::GetCurrentProcess().Id)" "$(Split-Path $MyInvocation.PSCommandPath -Leaf)" "$MyInvocation.ScriptLineNumber" "ProfileLoad" "EXEC: Install-Module -Name $ModuleName -Scope CurrentUser -Force -AllowClobber";
				}

				Import-Module -Name "$ModuleName" -Scope Global -Verbose:$false
				$ExitCode = $LastExitCode

				if ($ExitCode -ne 0) {
					if (!([string]::IsNullOrEmpty("$LoggingLoaded"))) {
						writeLogEntry "FILE" "ERROR" "$([System.Diagnostics.Process]::GetCurrentProcess().Id)" "$(Split-Path $MyInvocation.PSCommandPath -Leaf)" "$MyInvocation.ScriptLineNumber" "ProfileLoad" "Failed to install module $ModuleName with return code $ExitCode";
						writeLogEntry "CONSOLE" "STDERR" "$([System.Diagnostics.Process]::GetCurrentProcess().Id)" "$(Split-Path $MyInvocation.PSCommandPath -Leaf)" "$MyInvocation.ScriptLineNumber" "ProfileLoad" "Failed to install module $ModuleName with return code $ExitCode";
					}
				}
			}
		}
	}
}
