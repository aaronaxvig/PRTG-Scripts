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

$SnmpInfo.OID = '1.3.6.1.4.1.6574.102'
$results = Invoke-SNMPv3Walk @SnmpInfo

Prtg {
    $volumeCount = 1

    while ($results | Where-Object { $_.OID -eq "1.3.6.1.4.1.6574.102.1.1.1.$volumeCount" }) {
        # Sensible default name
        $volumeName = "Disk $volumeCount"

        if ($results | Where-Object { $_.OID -eq "1.3.6.1.4.1.6574.102.1.1.2.$volumeCount" }) {
            $volumeName = ($results | Where-Object { $_.OID -eq "1.3.6.1.4.1.6574.102.1.1.2.$volumeCount" } | Select-Object -ExpandProperty Value).ToString()
        }

        if ($results | Where-Object { $_.OID -eq "1.3.6.1.4.1.6574.102.1.1.5.$volumeCount" }) {
            Result {
                Channel "$volumeName read operations"
                $value = $results | Where-Object { $_.OID -eq "1.3.6.1.4.1.6574.102.1.1.5.$volumeCount" } | Select-Object -ExpandProperty Value
                Value ([int]$value.ToString())
                Unit 'Operations'
                Mode 'Difference'
            }
        }

        if ($results | Where-Object { $_.OID -eq "1.3.6.1.4.1.6574.102.1.1.6.$volumeCount" }) {
            Result {
                Channel "$volumeName write operations"
                $value = $results | Where-Object { $_.OID -eq "1.3.6.1.4.1.6574.102.1.1.6.$volumeCount" } | Select-Object -ExpandProperty Value
                Value ([int]$value.ToString())
                Unit 'Operations'
                Mode 'Difference'
            }
        }

        if ($results | Where-Object { $_.OID -eq "1.3.6.1.4.1.6574.102.1.1.8.$volumeCount" }) {
            Result {
                Channel "$volumeName load average"
                $value = $results | Where-Object { $_.OID -eq "1.3.6.1.4.1.6574.102.1.1.8.$volumeCount" } | Select-Object -ExpandProperty Value
                Value ([int]$value.ToString())
                Unit 'Percent'
            }
        }

        if ($results | Where-Object { $_.OID -eq "1.3.6.1.4.1.6574.102.1.1.9.$volumeCount" }) {
            Result {
                Channel "$volumeName load average 1 min"
                $value = $results | Where-Object { $_.OID -eq "1.3.6.1.4.1.6574.102.1.1.9.$volumeCount" } | Select-Object -ExpandProperty Value
                Value ([int]$value.ToString())
                Unit 'Percent'
            }
        }

        if ($results | Where-Object { $_.OID -eq "1.3.6.1.4.1.6574.102.1.1.10.$volumeCount" }) {
            Result {
                Channel "$volumeName load average 5 min"
                $value = $results | Where-Object { $_.OID -eq "1.3.6.1.4.1.6574.102.1.1.10.$volumeCount" } | Select-Object -ExpandProperty Value
                Value ([int]$value.ToString())
                Unit 'Percent'
            }
        }

        if ($results | Where-Object { $_.OID -eq "1.3.6.1.4.1.6574.102.1.1.11.$volumeCount" }) {
            Result {
                Channel "$volumeName load average 15 min"
                $value = $results | Where-Object { $_.OID -eq "1.3.6.1.4.1.6574.102.1.1.11.$volumeCount" } | Select-Object -ExpandProperty Value
                Value ([int]$value.ToString())
                Unit 'Percent'
            }
        }

        if ($results | Where-Object { $_.OID -eq "1.3.6.1.4.1.6574.102.1.1.12.$volumeCount" }) {
            Result {
                Channel "$volumeName read total"
                $value = $results | Where-Object { $_.OID -eq "1.3.6.1.4.1.6574.102.1.1.12.$volumeCount" } | Select-Object -ExpandProperty Value
                Value ([long]$value.ToString())
                Unit 'BytesDisk'
            }
        }

        if ($results | Where-Object { $_.OID -eq "1.3.6.1.4.1.6574.102.1.1.13.$volumeCount" }) {
            Result {
                Channel "$volumeName write total"
                $value = $results | Where-Object { $_.OID -eq "1.3.6.1.4.1.6574.102.1.1.13.$volumeCount" } | Select-Object -ExpandProperty Value
                Value ([long]$value.ToString())
                Unit 'BytesDisk'
            }
        }

        if ($results | Where-Object { $_.OID -eq "1.3.6.1.4.1.6574.102.1.1.12.$volumeCount" }) {
            Result {
                Channel "$volumeName read activity"
                $value = $results | Where-Object { $_.OID -eq "1.3.6.1.4.1.6574.102.1.1.12.$volumeCount" } | Select-Object -ExpandProperty Value
                Value ([long]$value.ToString())
                Unit 'BytesDisk'
                Mode 'Difference'
            }
        }

        if ($results | Where-Object { $_.OID -eq "1.3.6.1.4.1.6574.102.1.1.13.$volumeCount" }) {
            Result {
                Channel "$volumeName write activity"
                $value = $results | Where-Object { $_.OID -eq "1.3.6.1.4.1.6574.102.1.1.13.$volumeCount" } | Select-Object -ExpandProperty Value
                Value ([long]$value.ToString())
                Unit 'BytesDisk'
                Mode 'Difference'
            }
        }

        $volumeCount++
    }
}