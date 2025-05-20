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

Function Build-New-System() {
    Write-Output "Installing Chocolatey: $(Install-Chocolatey; Write-Output "Return code: $LastExitCode")"
    Write-Output "Installing Chocolatey Applications: $(Install-From-Chocolatey; Write-Output "Return code: $LastExitCode")"

    Write-Output "Installing Applications from internet..."
    Write-Output "Installing Lenovo Service Bridge: $(Install-Lenovo-LSB; Write-Output "Return code: $LastExitCode")"

    Write-Output "Installing Applications from WinGet..."
    Write-Output "Installing UpNote: $(Install-UpNote; Write-Output "Return code: $LastExitCode")"
    Write-Output "Installing WhatsApp: $(Install-WhatsApp; Write-Output "Return code: $LastExitCode")"
    Write-Output "Installing SysInternals: $(Install-SysInternals; Write-Output "Return code: $LastExitCode")"
    Write-Output "Installing Visual Studio Code: $(Install-VSCode; Write-Output "Return code: $LastExitCode")"
    Write-Output "Installing Acrobat Reader: $(Install-Acrobat; Write-Output "Return code: $LastExitCode")"
}
