<#
#==============================================================================
#
#          FILE:  apps.ps1
#         USAGE:  powershell -NoExit -File "apps.ps1"
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

function Install-From-Chocolatey() {
    if (Test-Path -Path "$([Environment]::GetFolderPath("ProgramData"))/chocolatey/choco.exe" -PathType Leaf) {
        if (Test-Path -Path "$([Environment]::GetFolderPath("Personal"))/Documents/Chocolatey/packages.config" -Type Leaf) {
            $ProcessParams = @{
                 FilePath = "$([Environment]::GetFolderPath("ProgramData"))/chocolatey/choco.exe"
                 ArgumentList = "install $([Environment]::GetFolderPath("Personal"))/Documents/Chocolatey/packages.config --virus -y"
            }

            Start-Process ${ProcessParams} -Wait
            $ExitCode = ${LastExitCode}

            Remove-Variable -Name ProcessParams
        } else {
            $ExitCode = 1

            Write-Error -Message "Package configuration file was not found. Unable to perform package installation." -Category ObjectNotFound
        }
    } else {
        $ExitCode = 1

        Write-Error -Message "Chocolatey is not installed, cannot install packages" -Category NotInstalled
    }

    return $ExitCode
}
