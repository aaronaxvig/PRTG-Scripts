#Requires -Modules PrtgXml
# Install-Module PrtgXml
# https://www.powershellgallery.com/packages/PrtgXml
# https://github.com/lordmilko/PrtgXml

Param(
    [Parameter(Mandatory=$false)]
    [string]
    $CheckFileRecencySettings = 'Check-FileRecency-Settings.ps1'
)

$path = Join-Path $PSScriptRoot $CheckFileRecencySettings
. $path
 
Prtg {
    foreach ($fileToCheck in $filesToCheck) {
        if (Test-Path -Path $fileToCheck.FileSearchString) {
            $files = Get-Item -Path $fileToCheck.FileSearchString
            $newest = $files | Sort-Object LastWriteTime -Descending | Select-Object -First 1
            $age = New-TimeSpan -Start $newest.LastWriteTime

            Result {
                Channel "$($fileToCheck.NameForChannel) age OK"
                Value ([int]($age -lt $fileToCheck.MaximumAge))
                Unit 'Custom'
                ValueLookup "prtg.standardlookups.boolean.statetrueok"
            }

            Result {
                Channel "$($fileToCheck.NameForChannel) size OK"
                Value ([int]($newest.Length -gt $fileToCheck.MinimumSize))
                Unit 'Custom'
                ValueLookup "prtg.standardlookups.boolean.statetrueok"
            }
        }
        else {
            Error 1
            Text "No $($fileToCheck.NameForChannel) files found with search string $($fileToCheck.FileSearchString).  Aborting further checks."
            break
        }
    }
}