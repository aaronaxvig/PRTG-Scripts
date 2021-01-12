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

    while ($results | Where-Object { $_.OID -eq "1.3.6.1.4.1.6574.3.1.1.1.$raidCount" }) {
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