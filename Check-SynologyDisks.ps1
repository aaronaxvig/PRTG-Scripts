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

$SnmpInfo.OID = '1.3.6.1.4.1.6574.2'
$results = Invoke-SNMPv3Walk @SnmpInfo

Prtg {
    $diskCount = 0

    while ($results | Where-Object { $_.OID -eq "1.3.6.1.4.1.6574.2.1.1.1.$diskCount" }) {
        # Sensible default name
        $diskId = "Disk $diskCount"

        if ($results | Where-Object { $_.OID -eq "1.3.6.1.4.1.6574.2.1.1.2.$diskCount" }) {
            $diskId = ($results | Where-Object { $_.OID -eq "1.3.6.1.4.1.6574.2.1.1.2.$diskCount" } | Select-Object -ExpandProperty Value).ToString()
        }

        if ($results | Where-Object { $_.OID -eq "1.3.6.1.4.1.6574.2.1.1.3.$diskCount" }) {
            Result {
                $diskModel = ($results | Where-Object { $_.OID -eq "1.3.6.1.4.1.6574.2.1.1.3.$diskCount" } | Select-Object -ExpandProperty Value).ToString().Trim()
                Channel "$diskId model: $diskModel"
                Value 0
            }
        }

        if ($results | Where-Object { $_.OID -eq "1.3.6.1.4.1.6574.2.1.1.4.$diskCount" }) {
            Result {
                $diskType = ($results | Where-Object { $_.OID -eq "1.3.6.1.4.1.6574.2.1.1.4.$diskCount" } | Select-Object -ExpandProperty Value).ToString().Trim()
                Channel "$diskId type: $diskType"
                Value 0
            }
        }

        if ($results | Where-Object { $_.OID -eq "1.3.6.1.4.1.6574.2.1.1.5.$diskCount" }) {
            Result {
                Channel "$diskId status"
                $value = $results | Where-Object { $_.OID -eq "1.3.6.1.4.1.6574.2.1.1.5.$diskCount" } | Select-Object -ExpandProperty Value
                Value ([int]$value.ToString())
                Unit 'Custom'
                ValueLookup "oid.synology-system-mib.synodisk.diskstatus"
            }
        }

        if ($results | Where-Object { $_.OID -eq "1.3.6.1.4.1.6574.2.1.1.6.$diskCount" }) {
            Result {
                Channel "$diskId temperature"
                $value = $results | Where-Object { $_.OID -eq "1.3.6.1.4.1.6574.2.1.1.6.$diskCount" } | Select-Object -ExpandProperty Value
                Value ([int]$value.ToString())
                Unit 'Temperature'
            }
        }

        $diskCount++
    }
}