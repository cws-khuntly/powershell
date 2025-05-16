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
    Get-PSDrive -PSProvider 'FileSystem' | Select-Object Name
    New-Item -ItemType Directory -Path "$(Get-PSDrive -PSProvider 'FileSystem' | Select-Object Name"
        New-Item -ItemType file -Path "C:\path\to\your\file.txt"
        Set-Content -Path "C:\path\to\your\file.txt" -Value "This is the content to write to the file."
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072;


        Start-Process wt -Verb runAs -ArgumentList "pwsh.exe -NoExit -Command $(${ArgumentList} -join ' ')
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
    $ExitCode = ${LastExitCode}

    return ${ExitCode}
}

Export-ModuleMember -Function installChocolateyPM
