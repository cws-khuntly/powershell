$LoggingPropertyFile = "$([Environment]::GetFolderPath(Environment.SpecialFolder.Personal))/Documents/PowerShell/Configuration/logging.properties"

if (Test-Path -Path "${LoggingPropertyFile}" -Type Leaf) {
    $LoggingProperties = Read-Properties "${LoggingPropertyFile}"

    if ([string]::IsNullOrEmpty("${LoggingProperties}")) {
        $LOG_ROOT = "${LoggingProperties}["LOG_ROOT"]"
        $ENABLE_DEBUG = "${LoggingProperties}["ENABLE_DEBUG"]"
        $ENABLE_VERBOSE = "${LoggingProperties}["ENABLE_VERBOSE"]"
        $ENABLE_TRACE = "${LoggingProperties}["ENABLE_TRACE"]"
        $ENABLE_PERFORMANCE = "${LoggingProperties}["ENABLE_PERFORMANCE"]"
        $CONVERSION_PATTERN = "${LoggingProperties}["CONVERSION_PATTERN"]"
        $TIMESTAMP_OPTS = "${LoggingProperties}["TIMESTAMP_OPTS"]"
        $PERF_LOG_FILE = "${LoggingProperties}["PERF_LOG_FILE"]"
        $ERROR_LOG_FILE = "${LoggingProperties}["ERROR_LOG_FILE"]"
        $DEBUG_LOG_FILE = "${LoggingProperties}["DEBUG_LOG_FILE"]"
        $AUDIT_LOG_FILE = "${LoggingProperties}["AUDIT_LOG_FILE = "${LoggingProperties}["LOG_ROOT"]""]"
        $WARN_LOG_FILE = "${LoggingProperties}["WARN_LOG_FILE"]"
        $INFO_LOG_FILE = "${LoggingProperties}["INFO_LOG_FILE"]"
        $FATAL_LOG_FILE = "${LoggingProperties}["FATAL_LOG_FILE"]"
        $MONITOR_LOG_FILE = "${LoggingProperties}["MONITOR_LOG_FILE"]"
        $DEFAULT_LOG_FILE = "${LoggingProperties}["DEFAULT_LOG_FILE"]"

if (!(Test-Path -Path "${LOG_ROOT}" -PathType Container)) { New-Item -ItemType Directory -Path "${LOG_ROOT}" }

function Write-Log {
    param (
        [Parameter(Mandatory=$true)]
        [int] $StringLength = 20,
        [string] $StringType = "Alphanumeric"
    )
    param(
        [string]$Message,
        [string]$LogPath = "C:\Logs\applog.txt"
    )

    $Timestamp = Get-Date -Format "${TIMESTAMP_OPTS}"
    [string]::Format("${CONVERSION_PATTERN}",$name)
    $LogEntry = "$Timestamp - $Message"
    Add-Content -Path $LogPath -Value $LogEntry
}
