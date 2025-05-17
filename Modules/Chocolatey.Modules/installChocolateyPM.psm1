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

Function installChocolateyPM {
    $InstallFile = New-TemporaryFile

    if ((Test-Path -Path "${InstallFile}" -PathType Leaf) -and ($(Get-Acl "${InstallFile}").Access -Match "Write")) {
        $FileContent = New-Object System.Text.StringBuilder
        ${FileContent}.AppendLine("[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072;")
        ${FileContent}.AppendLine()
        ${FileContent}.AppendLine("Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))")
        ${FileContent}.AppendLine()
        ${FileContent}.AppendLine("$ExitCode = ${LastExitCode}")
        ${FileContent}.AppendLine()
        ${FileContent}.AppendLine("return ${Exit code}")
        ${FileContent}.AppendLine()

        Set-Content -Path "${InstallFile}" -Value "${FileContent}.ToString()"

        Start-Process powershell -Verb RunAs -ArgumentList '-ExecutionPolicy Bypass', '-File', '${InstallFile}'
        $ExitCode = ${LastExitCode}
    } else {
        $ExitCode = 1

        Write-Error -Message "Unable to create temporary file"
    }

    Remove-Item -Path "${InstallFile}" -Force

    return ${ExitCode}
}

Export-ModuleMember -Function installChocolateyPM
