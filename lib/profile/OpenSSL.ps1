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

Function Connect-Via-OpenSSL() {
    param (
        [Parameter(Mandatory=$true)]
        [string] $TargetHost,
        [int] $TargetPort = 443
    )

	Write-Output "openssl s_client -status -connect ${TargetHost}:${TargetPort}"
	openssl s_client -status -connect "${TargetHost}":"${TargetPort}"
}
