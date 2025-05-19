Function Get-Properties() {
    param (
        [Parameter(Mandatory=$true)]
        [string] $InputFile
    )

    $ReturnedProperties = @()

    Get-Content "$InputFile" | Select-String -NotMatch "^#|^$|^;" | Select-String "=" | ForEach-Object {
        if (!([string]::IsNullOrWhiteSpace(${_}))) {
            $FileEntryKey, $FileEntryValue = $_ -Split "=", 2

            $PropertyObject = [PSCustomObject]@{
                Name = $FileEntryKey.Trim()
                Value = $ExecutionContext.InvokeCommand.ExpandString($($FileEntryValue -Replace "`"", "").Trim())
            }

			$ReturnedProperties += $PropertyObject
        }
    }

	return $ReturnedProperties
}
