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
    Write-Output "Installing WSL with Fedora 42: $(wsl --install -d FedoraLinux-42; wsl --export FedoraLinux-42 C:\Temp\FedoraLinux-42.tar; wsl --unregister FedoraLinux-42; wsl --import FedoraLinux-42 C:\Temp\FedoraLinux-42.tar D:\WSL\FedoraLinux-42; Remove-Item -Path C:\Temp\FedoraLinux-42.tar)"

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
