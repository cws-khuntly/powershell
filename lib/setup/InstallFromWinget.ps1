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

Function Install-UpNote() { winget install -e -i --id $(winget search UpNote --source=msstore) --source=msstore }

Function Install-WhatsApp() { winget install -e -i --id $(winget search WhatsApp --source=msstore) --source=msstore }

Function Install-SysInternala() { winget install -e -i --id $(winget search SysInternals --source=msstore) --source=msstore }

Function Install-VSCode() { winget install -e -i --id $(winget search vscode --source=msstore) --source=msstore }

Function Install-Acrobat() { winget install -e -i --id $(winget search "Adobe Acrobat Reader DC" --source=msstore) --source=msstore }
