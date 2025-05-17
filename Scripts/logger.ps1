$LoggingPropertyFile = "$([Environment]::GetFolderPath(Environment.SpecialFolder.Personal))/Documents/PowerShell/Configuration/logging.properties"

if (Test-Path -Path "${LoggingPropertyFile}" -Type Leaf) {
    $LoggingProperties = Read-Properties "${LoggingPropertyFile}"

    if ([string]::IsNullOrEmpty($LoggingProperties)) {
        $LogDirectory = ${LoggingProperties}["

# Access properties like:
$properties["propertyName"]

function Write-Log {
    param(
        [string]$Message,
        [string]$LogPath = "C:\Logs\applog.txt"
    )
    $Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $LogEntry = "$Timestamp - $Message"
    Add-Content -Path $LogPath -Value $LogEntry
}

Write-Log -Message "Application started"
# ... your script code ...
Write-Log -Message "Task completed"