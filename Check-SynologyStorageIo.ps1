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

$SnmpInfo.OID = '1.3.6.1.4.1.6574.101'
$results = Invoke-SNMPv3Walk @SnmpInfo

Prtg {
    $deviceCount = 1

    while ($results | Where-Object { $_.OID -eq "1.3.6.1.4.1.6574.101.1.1.1.$deviceCount" }) {
        # Sensible default name
        $deviceName = "Disk $deviceCount"

        if ($results | Where-Object { $_.OID -eq "1.3.6.1.4.1.6574.101.1.1.2.$deviceCount" }) {
            $deviceName = ($results | Where-Object { $_.OID -eq "1.3.6.1.4.1.6574.101.1.1.2.$deviceCount" } | Select-Object -ExpandProperty Value).ToString()
        }

        if ($results | Where-Object { $_.OID -eq "1.3.6.1.4.1.6574.101.1.1.5.$deviceCount" }) {
            Result {
                Channel "$deviceName read operations"
                $value = $results | Where-Object { $_.OID -eq "1.3.6.1.4.1.6574.101.1.1.5.$deviceCount" } | Select-Object -ExpandProperty Value
                Value ([int]$value.ToString())
                Unit 'Operations'
                Mode 'Difference'
            }
        }

        if ($results | Where-Object { $_.OID -eq "1.3.6.1.4.1.6574.101.1.1.6.$deviceCount" }) {
            Result {
                Channel "$deviceName write operations"
                $value = $results | Where-Object { $_.OID -eq "1.3.6.1.4.1.6574.101.1.1.6.$deviceCount" } | Select-Object -ExpandProperty Value
                Value ([int]$value.ToString())
                Unit 'Operations'
                Mode 'Difference'
            }
        }

        if ($results | Where-Object { $_.OID -eq "1.3.6.1.4.1.6574.101.1.1.8.$deviceCount" }) {
            Result {
                Channel "$deviceName load average"
                $value = $results | Where-Object { $_.OID -eq "1.3.6.1.4.1.6574.101.1.1.8.$deviceCount" } | Select-Object -ExpandProperty Value
                Value ([int]$value.ToString())
                Unit 'Percent'
            }
        }

        if ($results | Where-Object { $_.OID -eq "1.3.6.1.4.1.6574.101.1.1.9.$deviceCount" }) {
            Result {
                Channel "$deviceName load average 1 min"
                $value = $results | Where-Object { $_.OID -eq "1.3.6.1.4.1.6574.101.1.1.9.$deviceCount" } | Select-Object -ExpandProperty Value
                Value ([int]$value.ToString())
                Unit 'Percent'
            }
        }

        if ($results | Where-Object { $_.OID -eq "1.3.6.1.4.1.6574.101.1.1.10.$deviceCount" }) {
            Result {
                Channel "$deviceName load average 5 min"
                $value = $results | Where-Object { $_.OID -eq "1.3.6.1.4.1.6574.101.1.1.10.$deviceCount" } | Select-Object -ExpandProperty Value
                Value ([int]$value.ToString())
                Unit 'Percent'
            }
        }

        if ($results | Where-Object { $_.OID -eq "1.3.6.1.4.1.6574.101.1.1.11.$deviceCount" }) {
            Result {
                Channel "$deviceName load average 15 min"
                $value = $results | Where-Object { $_.OID -eq "1.3.6.1.4.1.6574.101.1.1.11.$deviceCount" } | Select-Object -ExpandProperty Value
                Value ([int]$value.ToString())
                Unit 'Percent'
            }
        }

        if ($results | Where-Object { $_.OID -eq "1.3.6.1.4.1.6574.101.1.1.12.$deviceCount" }) {
            Result {
                Channel "$deviceName read total"
                $value = $results | Where-Object { $_.OID -eq "1.3.6.1.4.1.6574.101.1.1.12.$deviceCount" } | Select-Object -ExpandProperty Value
                Value ([long]$value.ToString())
                Unit 'BytesDisk'
            }
        }

        if ($results | Where-Object { $_.OID -eq "1.3.6.1.4.1.6574.101.1.1.13.$deviceCount" }) {
            Result {
                Channel "$deviceName write total"
                $value = $results | Where-Object { $_.OID -eq "1.3.6.1.4.1.6574.101.1.1.13.$deviceCount" } | Select-Object -ExpandProperty Value
                Value ([long]$value.ToString())
                Unit 'BytesDisk'
            }
        }

        if ($results | Where-Object { $_.OID -eq "1.3.6.1.4.1.6574.101.1.1.12.$deviceCount" }) {
            Result {
                Channel "$deviceName read activity"
                $value = $results | Where-Object { $_.OID -eq "1.3.6.1.4.1.6574.101.1.1.12.$deviceCount" } | Select-Object -ExpandProperty Value
                Value ([long]$value.ToString())
                Unit 'BytesDisk'
                Mode 'Difference'
            }
        }

        if ($results | Where-Object { $_.OID -eq "1.3.6.1.4.1.6574.101.1.1.13.$deviceCount" }) {
            Result {
                Channel "$deviceName write activity"
                $value = $results | Where-Object { $_.OID -eq "1.3.6.1.4.1.6574.101.1.1.13.$deviceCount" } | Select-Object -ExpandProperty Value
                Value ([long]$value.ToString())
                Unit 'BytesDisk'
                Mode 'Difference'
            }
        }

        $deviceCount++
    }
}