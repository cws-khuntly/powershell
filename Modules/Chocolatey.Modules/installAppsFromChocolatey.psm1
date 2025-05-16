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

function installAppsFromChocolatey
{
    $ProcessParams = @{
        FilePath = "C:/ProgramData/chocolatey/choco.exe"
        ArgumentList = "install $env:UserProfile/Documents/Chocolatey/packages.config --virus -y"

    Start-Process $ProcessParams -Wait
    $ExitCode = $LastExitCode

    return $ExitCode
}

Export-ModuleMember -Function installAppsFromChocolatey
