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
#         NOTES:  ---
#        AUTHOR:  Kevin Huntly <kmhuntly@gmail.com>
#       COMPANY:  ---
#       VERSION:  1.0
#       CREATED:  ---
#      REVISION:  ---
#
#==============================================================================
#>

if (Test-Path -Path "$LoggingProperties" -Type Leaf) {
    $LogConfiguration = Get-Properties "$LoggingProperties"

    if (($null -eq $LogConfiguration) -or ($LogConfiguration.Count -eq 0)) {
        Write-Error -Message "Failed to load logging configuration. No logging available!"
    } else {
        $LogRoot = $LogConfiguration['LOG_ROOT']

        if (!(Test-Path -Path $LogRoot -PathType Container)) { New-Item -ItemType Directory -Path $LogRoot }

        setLoggingSession
    }
} else {
    Write-Error -Message "Logging configuration file not found. No logging available!"
}

Function setLoggingSession() {
    Set-Variable -Name "LoggingLoaded" -Value $true -Scope Global

    Set-Variable -Name "IsDebugEnabled" -Value $LogConfiguration['ENABLE_DEBUG'] -Scope Session
    Set-Variable -Name "IsVerboseEnabled" -Value $LogConfiguration['ENABLE_VERBOSE'] -Scope Session
    Set-Variable -Name "IsTraceEnabled" -Value $LogConfiguration['ENABLE_TRACE'] -Scope Session
    Set-Variable -Name "IsPerfEnabled" -Value $LogConfiguration['ENABLE_PERFORMANCE'] -Scope Session
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
        "[Cc][Oo][Nn][SS][Oo][Ll][Ee]" { writeLogEntryToConsole "$LogLevel" "$LogMessage" }
        "[Ff][Ii][Ll][Ee]" { writeLogEntryToFile "$LogType", "$LogLevel", "$ProcessID", "$ClassName", "$LineNumber", "$FunctionName", "$LogMessage" }
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
        "[Ss][Tt][Dd][Oo][UU][Tt]" { Write-Output -Message "$LogMessage" }
        "[Ss][Tt][Dd][Ee][Rr][Rr]" { Write-Error -Message "$LogMessage" }
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
        "[Pp][Ee][Rr][Ff][Oo][Rr][Mm][Aa][Nn][Cc][Ee]|[Pp][Ee][Rr][Ff]" { $LogFile = $LogConfiguration['PERF_LOG_FILE'] }
        "[Ff][Aa][Tt][Aa][Ll]" { $LogFile = $LogConfiguration['FATAL_LOG_FILE'] }
        "[Ee][Rr][Rr][Oo][Rr]" { $LogFile = $LogConfiguration['ERROR_LOG_FILE'] }
        "[Ww][Aa][Rr][Nn]" { $LogFile = $LogConfiguration['WARN_LOG_FILE'] }
        "[Ii][Nn][Ff][Oo]" { $LogFile = $LogConfiguration['INFO_LOG_FILE'] }
        "[Aa][Uu][Dd][Ii][Tt]" { $LogFile = $LogConfiguration['AUDIT_LOG_FILE'] }
        "[Dd][Ee][Bb][Uu][Gg]" { $LogFile = $LogConfiguration['DEBUG_LOG_FILE'] }
        "[Mm][Oo][Nn][Ii][Tt][Oo][Rr]" { $LogFile = $LogConfiguration['MONITOR_LOG_FILE'] }
        default { $LogFile = $LogConfiguration['DEFAULT_LOG_FILE'] }
    }

    $LogEntry = [string]::Format($LogConfiguration['CONVERSION_PATTERN'],
        "$(Get-Date -Format $LogConfiguration['TIMESTAMP_OPTS'])", "$LogFile", "$LogLevel", "$ProcessID", "$ClassName", "$LineNumber", "$FunctionName", "$LogMessage")

    if (!(Test-Path -Path "$LogRoot/$LogFile" -PathType Leaf)) { New-Item -ItemType File -Path "$LogRoot/$LogFile" }
    Add-Content -Path "$LogRoot/$LogFile" -Value "$LogEntry"
}
