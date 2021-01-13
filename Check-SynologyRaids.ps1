#Requires -Modules SNMPv3
# Install-Module SNMPv3
# https://www.powershellgallery.com/packages/SNMPv3

#Requires -Modules PrtgXml
# Install-Module PrtgXml
# https://www.powershellgallery.com/packages/PrtgXml
# https://github.com/lordmilko/PrtgXml

[System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingPlainTextForPassword", "SnmpCredentialsFile")]
Param(
    [Parameter(Mandatory=$true)]
    [string]
    $Target,

    [Parameter(Mandatory=$false)]
    [string]
    $SnmpCredentialsFile = 'SnmpCredentials.ps1'
)

$path = Join-Path $PSScriptRoot $SnmpCredentialsFile
. $path

$SnmpInfo.Target = $Target

$SnmpInfo.OID = '1.3.6.1.4.1.6574.3'
$results = Invoke-SNMPv3Walk @SnmpInfo

Prtg {
    $raidCount = 0

    # A DS218j running DSM 6.2.2-24922 was observed to be missing 6574.3.1.1.1.0 (the index column of the table).
    # In that case, the first entry under 6574.2 was 6574.3.1.1.2.0 (the name column of the table).
    # It seems preferable to use the index if it is available, so we check and substitute if it is not.
    # This is documented as fixed in an update and updating DID resolve the issue: https://www.synology.com/en-us/releaseNote/DSM?model=DS218j#ver_25426
    # "Fixed the issue where SNMP did not provide the indices of Disk and RAID correctly."
    $loopOid = "1.3.6.1.4.1.6574.3.1.1.2"
    if ($results | Where-Object { $_.OID -eq "1.3.6.1.4.1.6574.3.1.1.1.$raidCount" }) {
        $loopOid = "1.3.6.1.4.1.6574.3.1.1.1"
    }

    while ($results | Where-Object { $_.OID -eq "$loopOid.$raidCount" }) {
        # Sensible default name
        $raidName = "Disk $raidCount"
        $freeSize = 0
        $totalSize = 0

        if ($results | Where-Object { $_.OID -eq "1.3.6.1.4.1.6574.3.1.1.2.$raidCount" }) {
            $raidName = ($results | Where-Object { $_.OID -eq "1.3.6.1.4.1.6574.3.1.1.2.$raidCount" } | Select-Object -ExpandProperty Value).ToString()
        }

        if ($results | Where-Object { $_.OID -eq "1.3.6.1.4.1.6574.3.1.1.3.$raidCount" }) {
            Result {
                Channel "$raidName status"
                $value = $results | Where-Object { $_.OID -eq "1.3.6.1.4.1.6574.3.1.1.3.$raidCount" } | Select-Object -ExpandProperty Value
                Value ([int]$value.ToString())
                Unit 'Custom'
                ValueLookup "oid.synology-system-mib.synoraid.raidstatus"
            }
        }

        if ($results | Where-Object { $_.OID -eq "1.3.6.1.4.1.6574.3.1.1.4.$raidCount" }) {
            $value = $results | Where-Object { $_.OID -eq "1.3.6.1.4.1.6574.3.1.1.4.$raidCount" } | Select-Object -ExpandProperty Value
            $freeSize = [long]$value.ToString()

            Result {
                Channel "$raidName free size"
                Value $freeSize
                Unit 'BytesDisk'
            }
        }

        if ($results | Where-Object { $_.OID -eq "1.3.6.1.4.1.6574.3.1.1.5.$raidCount" }) {
            $value = $results | Where-Object { $_.OID -eq "1.3.6.1.4.1.6574.3.1.1.5.$raidCount" } | Select-Object -ExpandProperty Value
            $totalSize = [long]$value.ToString()

            Result {
                Channel "$raidName total size"
                Value $totalSize
                Unit 'BytesDisk'
            }
        }
        
        if ($freeSize -gt 0) {
            if ($totalSize -gt 0) {
                Result {
                    Channel "$raidName percent free"
                    Value ([int](($freeSize / $totalSize) * 100))
                    Unit 'Percent'
                }
            }
        }

        $raidCount++
    }
}