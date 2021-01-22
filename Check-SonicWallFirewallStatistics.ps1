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

$SnmpInfo.OID = '1.3.6.1.4.1.8741.1.3.1'
$results = Invoke-SNMPv3Walk @SnmpInfo

Prtg {
    if ($results | Where-Object { $_.OID -eq "1.3.6.1.4.1.8741.1.3.1.1.0" }) {
        $value = $results | Where-Object { $_.OID -eq "1.3.6.1.4.1.8741.1.3.1.1.0" } | Select-Object -ExpandProperty Value
        $capacity = ([int]$value.ToString())

        Result {
            Channel "Connection cache entries capacity"
            Value $capacity
            Unit 'Count'
        }

        if ($results | Where-Object { $_.OID -eq "1.3.6.1.4.1.8741.1.3.1.2.0" }) {
            $value = $results | Where-Object { $_.OID -eq "1.3.6.1.4.1.8741.1.3.1.2.0" } | Select-Object -ExpandProperty Value
            $entries = [int]$value.ToString()

            Result {
                Channel "Connection cache entries"
                Value $entries
                Unit 'Count'
            }

            Result {
                Channel "Connection cache utilization"
                Value ([int](($entries / $capacity) * 100))
                Unit 'Percent'
                LimitMaxWarning 90
            }
        }
    }

    if ($results | Where-Object { $_.OID -eq "1.3.6.1.4.1.8741.1.3.1.3.0" }) {
        Result {
            Channel "CPU utilization"
            $value = $results | Where-Object { $_.OID -eq "1.3.6.1.4.1.8741.1.3.1.3.0" } | Select-Object -ExpandProperty Value
            Value ([int]$value.ToString())
            Unit 'Percent'
        }
    }

    if ($results | Where-Object { $_.OID -eq "1.3.6.1.4.1.8741.1.3.1.4.0" }) {
        Result {
            Channel "RAM utilization"
            $value = $results | Where-Object { $_.OID -eq "1.3.6.1.4.1.8741.1.3.1.4.0" } | Select-Object -ExpandProperty Value
            Value ([int]$value.ToString())
            Unit 'Percent'
        }
    }
    
    if ($results | Where-Object { $_.OID -eq "1.3.6.1.4.1.8741.1.3.1.5.0" }) {
        Result {
            Channel "NAT translations"
            $value = $results | Where-Object { $_.OID -eq "1.3.6.1.4.1.8741.1.3.1.5.0" } | Select-Object -ExpandProperty Value
            Value ([int]$value.ToString())
            Unit 'Count'
        }
    }
    
    if ($results | Where-Object { $_.OID -eq "1.3.6.1.4.1.8741.1.3.1.6.0" }) {
        Result {
            Channel "Management CPU utilization"
            $value = $results | Where-Object { $_.OID -eq "1.3.6.1.4.1.8741.1.3.1.6.0" } | Select-Object -ExpandProperty Value
            Value ([int]$value.ToString())
            Unit 'Percent'
        }
    }
    
    if ($results | Where-Object { $_.OID -eq "1.3.6.1.4.1.8741.1.3.1.7.0" }) {
        Result {
            Channel "Fowarding/inspection CPU utilization"
            $value = $results | Where-Object { $_.OID -eq "1.3.6.1.4.1.8741.1.3.1.7.0" } | Select-Object -ExpandProperty Value
            Value ([int]$value.ToString())
            Unit 'Percent'
        }
    }

    if ($results | Where-Object { $_.OID -eq "1.3.6.1.4.1.8741.1.3.1.9.0" }) {
        Result {
            Channel "Content Filtering Service status"
            $value = $results | Where-Object { $_.OID -eq "1.3.6.1.4.1.8741.1.3.1.9.0" } | Select-Object -ExpandProperty Value
            Value ([int]$value.ToString())
            Unit 'Custom'
            ValueLookup "oid.sonicwall-firewall-ip-statistics-mib.sonicwall-fw-stats.soniccfs"
        }
    }
}