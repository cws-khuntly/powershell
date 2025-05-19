$LoggingPropertyFile = "$([Environment]::GetFolderPath("Personal"))/PowerShell/config/system/logging.properties"

if (Test-Path -Path "${LoggingPropertyFile}" -Type Leaf) {
    $LoggingProperties = Get-Properties "${LoggingPropertyFile}"

    if (($null -eq ${LoggingProperties}) -or (${LoggingProperties.Count} -eq 0)) {
        $LogRoot = $LoggingProperties | Where-Object {$_.Name -Match "LOG_ROOT"}

        if (!(Test-Path -Path ${LogRoot} -PathType Container)) { New-Item -ItemType Directory -Path ${LogRoot} }

        setLoggingSession
    } else {
        Write-Error -Message "Failed to load logging configuration. No logging available!"
    }
} else {
    Write-Error -Message "Failed to load logging configuration. No logging available!"
}

Function setLoggingSession() {
    Set-Variable -Name "LoggingLoaded" -Value $true -Scope Global

    Set-Variable -Name "IsDebugEnabled" -Value $($LoggingProperties | Where-Object {$_.Name -Match "ENABLE_DEBUG"}) -Scope Session
    Set-Variable -Name "IsVerboseEnabled" -Value $($LoggingProperties | Where-Object {$_.Name -Match "ENABLE_VERBOSE"}) -Scope Session
    Set-Variable -Name "IsTraceEnabled" -Value $($LoggingProperties | Where-Object {$_.Name -Match "ENABLE_TRACE"}) -Scope Session
    Set-Variable -Name "IsPerfEnabled" -Value $($LoggingProperties | Where-Object {$_.Name -Match "ENABLE_PERFORMANCE"}) -Scope Session
}

Function writeLogEntry() {
    param (
        [Parameter(Mandatory=$true)]
        [string] $LogType,
        [Parameter(Mandatory=$true)]
        [string] $LogLevel,
        [int] $ProcessID,
        [string] $ClassName,
        [int] $LineNumber,
        [string] $FunctionName,
        [Parameter(Mandatory=$true)]
        [string] $LogMessage
    )

    Switch -Regex ("${LogType}") {
        "[Cc][Oo][Nn][SS][Oo][Ll][Ee]" { writeLogEntryToConsole "${LogLevel}" "${LogMessage}" }
        "[Ff][Ii][Ll][Ee]" { writeLogEntryToFile "${LogType}", "${LogLevel}", "${ProcessID}", "${ClassName}", "${LineNumber}", "${FunctionName}", "${LogMessage}" }
    }
}

Function writeLogEntryToConsole() {
    param (
        [Parameter(Mandatory=$true)]
        [string] $LogLevel,
        [Parameter(Mandatory=$true)]
        [string] $LogMessage
    )

    Switch -Regex (${LogLevel}) {
        "[Ss][Tt][Dd][Oo][UU][Tt]" { Write-Output -Message "${LogMessage}" }
        "[Ss][Tt][Dd][Ee][Rr][Rr]" { Write-Error -Message "${LogMessage}" }
    }
}

Function writeLogEntryToFile() {
    param (
        [Parameter(Mandatory=$true)]
        [string] $LogType,
        [Parameter(Mandatory=$true)]
        [string] $LogLevel,
        [Parameter(Mandatory=$true)]
        [int] $ProcessID,
        [Parameter(Mandatory=$true)]
        [string] $ClassName,
        [Parameter(Mandatory=$true)]
        [int] $LineNumber,
        [Parameter(Mandatory=$true)]
        [string] $FunctionName,
        [Parameter(Mandatory=$true)]
        [string] $LogMessage
    )

    Switch -Regex ("${LogLevel}") {
        "[Pp][Ee][Rr][Ff][Oo][Rr][Mm][Aa][Nn][Cc][Ee]|[Pp][Ee][Rr][Ff]" { $LogFile = $($LoggingProperties | Where-Object {$_.Name -Match "PERF_LOG_FILE"}) }
        "[Ff][Aa][Tt][Aa][Ll]" { $LogFile = $($LoggingProperties | Where-Object {$_.Name -Match "FATAL_LOG_FILE"}) }
        "[Ee][Rr][Rr][Oo][Rr]" { $LogFile = $($LoggingProperties | Where-Object {$_.Name -Match "ERROR_LOG_FILE"}) }
        "[Ww][Aa][Rr][Nn]" { $LogFile = $($LoggingProperties | Where-Object {$_.Name -Match "WARN_LOG_FILE"}) }
        "[Ii][Nn][Ff][Oo]" { $LogFile = $($LoggingProperties | Where-Object {$_.Name -Match "INFO_LOG_FILE"}) }
        "[Aa][Uu][Dd][Ii][Tt]" { $LogFile = $($LoggingProperties | Where-Object {$_.Name -Match "AUDIT_LOG_FILE"}) }
        "[Dd][Ee][Bb][Uu][Gg]" { $LogFile = $($LoggingProperties | Where-Object {$_.Name -Match "DEBUG_LOG_FILE"}) }
        "[Mm][Oo][Nn][Ii][Tt][Oo][Rr]" { $LogFile = $($LoggingProperties | Where-Object {$_.Name -Match "MONITOR_LOG_FILE"}) }
        default { $LogFile = $($LoggingProperties | Where-Object {$_.Name -Match "DEFAULT_LOG_FILE"}) }
    }

    $LogEntry = [string]::Format($($LoggingProperties | Where-Object {$_.Name -Match "CONVERSION_PATTERN"}),
        "$(Get-Date -Format $($LoggingProperties | Where-Object {$_.Name -Match "TIMESTAMP_OPTS"}))", "${LogFile}", "${LogLevel}", "${ProcessID}", "${ClassName}", "${LineNumber}", "${FunctionName}", "${LogMessage}")

    if (!(Test-Path -Path "${LogRoot}/${LogFile}" -PathType Leaf)) { New-Item -ItemType File -Path "${LogRoot}/${LogFile}" }
    Add-Content -Path "${LogRoot}/${LogFile}" -Value "${LogEntry}"
}
