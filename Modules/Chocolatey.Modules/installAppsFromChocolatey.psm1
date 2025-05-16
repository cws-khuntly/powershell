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

function installAppsFromChocolatey {
    if (Test-Path -Path "C:/ProgramData/chocolatey/choco.exe" -PathType Leaf) {
        $ProcessParams = @{
            FilePath = "C:/ProgramData/chocolatey/choco.exe"
            ArgumentList = "install $([Environment]::GetFolderPath("Personal"))/Documents/Chocolatey/packages.config --virus -y"
        }

        Start-Process ${ProcessParams} -Wait
        $ExitCode = ${LastExitCode}

        Remove-Variable -Name ProcessParams

        return ${ExitCode}
    }
    else {
        Write-Error -Message "Chocolatey is not installed, cannot install packages" -Category NotInstalled
    }
}

Export-ModuleMember -Function installAppsFromChocolatey
