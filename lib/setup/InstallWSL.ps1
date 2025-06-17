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

Function Install-WSL() {
    Write-Output "Installing WSL with Fedora 42..."

    New-Item -ItemType Directory -Path "$([Environment]::GetFolderPath('TEMP'))"
    New-Item -ItemType Directory -Path "D:/WSL"
    Copy-Item -Path "$([Environment]::GetFolderPath('Personal'))/wslconfig" -Destination "$([Environment]::GetFolderPath('UserProfile'))/.wslconfig"

    wsl --install
    wsl --shutdown
    wsl --install -d FedoraLinux-42
    wsl --shutdown
    wsl --export FedoraLinux-42 "$([Environment]::GetFolderPath('TEMP'))/FedoraLinux-42.tar"
    wsl --unregister FedoraLinux-42
    wsl --import FedoraLinux-42 "$([Environment]::GetFolderPath('TEMP'))/FedoraLinux-42.tar" "D:\WSL\FedoraLinux-42"

    Remove-Item -Path "$([Environment]::GetFolderPath('TEMP'))/FedoraLinux-42.tar"

    Write-Output "Installation complete"
}
