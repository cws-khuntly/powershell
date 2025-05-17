$LoggingProperties = "path/to/your/file.properties"
$properties = @{}

Get-Content $filePath | ForEach-Object {
    if ($_ -match "=") {
        $key, $value = $_ -split "=", 2
        $properties[$key.Trim()] = $value.Trim()
    }
}

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