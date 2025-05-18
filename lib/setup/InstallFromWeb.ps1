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

Function Install-Lenovo-LSB() {
    $InstallFile = New-TemporaryFile

    Invoke-WebRequest -Uri "https://download.lenovo.com/lsbv4/LSBSetup.exe" -OutFile $InstallFile

    Start-Process -Wait -FilePath $InstallFile -ArgumentList "/S" -PassThru
    $ExitCode = $LastReturnCode

    if (Test-Path -Path $InstallFile -PathType Leaf) { Remove-Item -Path $InstallFile -Force }

    return $ExitCode
}
