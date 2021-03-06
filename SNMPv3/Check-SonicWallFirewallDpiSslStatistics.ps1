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

$SnmpInfo.OID = '1.3.6.1.4.1.8741.1.3.5'
$results = Invoke-SNMPv3Walk @SnmpInfo

Prtg {
    if ($results | Where-Object { $_.OID -eq "1.3.6.1.4.1.8741.1.3.5.3.0" }) {
        $value = $results | Where-Object { $_.OID -eq "1.3.6.1.4.1.8741.1.3.5.3.0" } | Select-Object -ExpandProperty Value
        $capacity = ([int]$value.ToString())

        Result {
            Channel "SSL inspection connection capacity"
            Value $capacity
            Unit 'Count'
        }

        if ($results | Where-Object { $_.OID -eq "1.3.6.1.4.1.8741.1.3.5.1.0" }) {
            $value = $results | Where-Object { $_.OID -eq "1.3.6.1.4.1.8741.1.3.5.1.0" } | Select-Object -ExpandProperty Value
            $connections = [int]$value.ToString()

            Result {
                Channel "SSL inspection connections"
                Value $connections
                Unit 'Count'
            }

            Result {
                Channel "SSL insepection utilization"
                Value ([int](($connections / $capacity) * 100))
                Unit 'Percent'
                LimitMaxWarning 90
            }
        }
    }

    if ($results | Where-Object { $_.OID -eq "1.3.6.1.4.1.8741.1.3.5.2.0" }) {
        Result {
            Channel "SSL inspection connections highwater"
            $value = $results | Where-Object { $_.OID -eq "1.3.6.1.4.1.8741.1.3.5.2.0" } | Select-Object -ExpandProperty Value
            Value ([int]$value.ToString())
            Unit 'Count'
        }
    }
}