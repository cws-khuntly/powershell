Function returnRandomCharacters() {
    param (
        [int] $StringLength = 20,
        [string] $StringType = "Alphanumeric"
    )

    $ReturnableCharacters = ""
    if ("${StringType}" -match "Numeric") { ${ReturnableCharacters} += "0123456789" }
    if ("${StringType}" -match "Lowercase") { ${ReturnableCharacters} += "abcdefghijklmnopqrstuvwxyz" }
    if ("${StringType}" -match "Uppercase") { ${ReturnableCharacters} += "ABCDEFGHIJKLMNOPQRSTUVWXYZ" }
    if ("${StringType}" -match "Symbol") { ${ReturnableCharacters} += "!@#$%^&*()_+-=[]{}|;':\\,./<>?" }
    if ("${StringType}" -match "Alphanumeric") { ${ReturnableCharacters} = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ" }
    if ("${StringType}" -match "All") { ${ReturnableCharacters} = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ!@#$%^&*()_+-=[]{}|;':\\,./<>?" }

    $ReturnedString = ""
    for ([int] ${i} = 0; ${i} -lt ${Length}; ${i++}) {
        $RandomIndex = Get-Random -Minimum 1 -Maximum (${ReturnableCharacters}.Length - 1)
        ${ReturnedString} += ${ReturnableCharacters}[${RandomIndex}]
    }

    return "${ReturnedString}"
}

Function uptime() {
	Get-WmiObject win32_operatingsystem | Select-Object csname, @{LABEL='LastBootUpTime';

	EXPRESSION={$_.ConverttoDateTime($_.lastbootuptime)}}
}

Function Clear-Cache() {
    # add clear cache logic here
    Write-Output "Clearing cache..." -ForegroundColor Cyan

    # Clear Windows Prefetch
    Write-Output "Clearing Windows Prefetch..." -ForegroundColor Yellow
    Remove-Item -Path "${env:SystemRoot}\Prefetch\*" -Force -ErrorAction SilentlyContinue

    # Clear Windows Temp
    Write-Output "Clearing Windows Temp..." -ForegroundColor Yellow
    Remove-Item -Path "${env:SystemRoot}\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue

    # Clear User Temp
    Write-Output "Clearing User Temp..." -ForegroundColor Yellow
    Remove-Item -Path "${env:TEMP}\*" -Recurse -Force -ErrorAction SilentlyContinue

    # Clear Internet Explorer Cache
    Write-Output "Clearing Internet Explorer Cache..." -ForegroundColor Yellow
    Remove-Item -Path "${env:LOCALAPPDATA}\Microsoft\Windows\INetCache\*" -Recurse -Force -ErrorAction SilentlyContinue

    Write-Output "Cache clearing completed." -ForegroundColor Green
}

Function prompt() {
    $uiTitle = "${PWD}" | Convert-Path | Split-Path -Leaf
    $Host.UI.RawUI.WindowTitle = "${uiTitle}"
    Write-Output "`n${env:USERNAME}" -ForegroundColor Green -NoNewline

    if (Test-Administrator) {
        Write-Output " as " -NoNewline
        Write-Output "Administrator" -ForegroundColor Red -NoNewline
        $Host.UI.RawUI.WindowTitle = ${uiTitle} + " (Administrator)"
    }

    Write-Output " at " -NoNewline
    Write-Output "${env:COMPUTERNAME}" -ForegroundColor Magenta -NoNewline
    Write-Output " in " -NoNewline
    Write-Output "${ExecutionContext.SessionState.Path.CurrentLocation}" -ForegroundColor Cyan -NoNewline
    $branch = try { git rev-parse --abbrev-ref HEAD 2>$null } catch { $null }

    if (${branch}){
        Write-Output " on " -NoNewline
        Write-Output "${branch}" -ForegroundColor Yellow -NoNewline
    }

    return "`nPS $('>' * (${NestedPromptLevel} + 1)) "
}

Function Get-PID-For-Port() {
    param (
        [Parameter(Mandatory=$true)]
        [int] $TargetPort
    )

	Get-Process -Id (Get-NetTCPConnection -LocalPort ${TargetPort}).OwningProcess
}

Function Write-Commit-Message() {
    $CommitMessage = Invoke-WebRequest -URI "https://whatthecommit.com/index.txt"

    if ([string]::IsNullOrEmpty($CommitMessage)) {
        return 1
    } else {
        git commit -sm "${CommitMessage}"

        Remove-Variable -Name CommitMessage
    }
}

Function admin {
    param (
        [Parameter(Mandatory=$true)]
        [string] $CommandToRun,
        [string] $ArgumentList
    )

    if ([string]::IsNullOrEmpty(${ArgumentList})) {
        Start-Process "${CommandToRun}" -Verb RunAs
    } else {
        Start-Process "${CommandToRun}" -Verb RunAs -ArgumentList "${ArgumentList}"
    }
}

Function flushdns {
    Clear-DnsClientCache

    Write-Output -Message "DNS has been flushed"
}

Function Return-Properties() {
    param (
        [Parameter(Mandatory=$true)]
        [string] $InputFile
    )

    $ReturnedProperties = @{}

    if ((Test-Path -Path "${InputFile}" -PathType Leaf) -and ((Get-Acl -Path "${InputFile").Access -Match "Read")) {
        Get-Content "${InputFile}" | ForEach-Object {
            if ($_ -Match "=") {
                $key, $value = $_ -split "=", 2
                ${ReturnedProperties}[$key.Trim()] = $value.Trim()
            }
        }
    } else {
        Write-Error -Message "File ${InputFile} was not found or could not be read." -Category ObjectNotFound
    }

    return "${ReturnedProperties}"
}
