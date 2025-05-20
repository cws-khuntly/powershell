<#
#==============================================================================
#
#          FILE:  InstallUpNote.ps1
#         USAGE:  powershell -NoExit -File "InstallUpNote.ps1"
#   DESCRIPTION:  Installs various desired packages using the Chocolatey Package Manager
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

Function Install-UpNote() { Install-WinGetPackage -Id "UpNotePte.Ltd.UpNote" -Name "UpNote"; return $LastExitCode }

Function Install-WhatsApp() { Install-WinGetPackage -Id "9NKSQGP7F2NH" -Name "WhatsApp"; return $LastExitCode }

Function Install-SysInternals() { Install-WinGetPackage -Id "Microsoft.Sysinternals" -Name "Sysinternals Suite"; return $LastExitCode }

Function Install-VSCode() { Install-WinGetPackage -Id "Microsoft.VisualStudioCode" -Name "Microsoft Visual Studio Code"; return $LastExitCode }

Function Install-VSCode-Extensions { Start-Process -Wait -FilePath "$([Environment]::GetFolderPath("ProgramFiles"))/Microsoft VS Code/code.exe" -ArgumentList "--install-extension vscode-modules.setup" -PassThru; return $LastExitCode }

Function Install-Acrobat() { Install-WinGetPackage -Id "Adobe.Acrobat.Reader.64-bit" -Name "Adobe Acrobat Reader (64-bit)"; return $LastExitCode }
