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
    $TempExe = New-TemporaryFile

    Invoke-WebRequest -Uri "https://download.lenovo.com/lsbv4/LSBSetup.exe" -OutFile $TempExe

    Start-Process -Wait -FilePath $TempExe -ArgumentList "/S" -PassThru
    $ExitCode = $LastReturnCode

    if (Test-Path -Path $TempExe -PathType Leaf) { Remove-Item -Path $TempExe -Force }

    return $ExitCode
}
