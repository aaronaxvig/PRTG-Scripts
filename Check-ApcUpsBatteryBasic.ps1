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

$SnmpInfo.OID = '1.3.6.1.4.1.318.1.1.1.2.1'
$results = Invoke-SNMPv3Walk @SnmpInfo

Prtg {
    if ($results | Where-Object { $_.OID -eq "1.3.6.1.4.1.318.1.1.1.2.1.1.0" }) {
        Result {
            Channel "Battery status"
            $value = $results | Where-Object { $_.OID -eq "1.3.6.1.4.1.318.1.1.1.2.1.1.0" } | Select-Object -ExpandProperty Value
            Value ([int]$value.ToString())
            Unit 'Custom'
            ValueLookup "oid.powernet-mib.upsbasicbattery.upsbasicbatterystatus"
        }
    }

    if ($results | Where-Object { $_.OID -eq "1.3.6.1.4.1.318.1.1.1.2.1.2.0" }) {
        Result {
            Channel "Time on battery"
            $value = $results | Where-Object { $_.OID -eq "1.3.6.1.4.1.318.1.1.1.2.1.2.0" } | Select-Object -ExpandProperty Value
            $parts = $value.ToString() -split ":"
            Value ([int]$parts[0] * 3600 + [int]$parts[1] * 60 + [int]$parts[2])
            Unit 'TimeSeconds'
        }
    }

    if ($results | Where-Object { $_.OID -eq "1.3.6.1.4.1.318.1.1.1.2.1.3.0" }) {
        Result {
            Channel "Battery age"
            $value = $results | Where-Object { $_.OID -eq "1.3.6.1.4.1.318.1.1.1.2.1.3.0" } | Select-Object -ExpandProperty Value
            Value ([int]((Get-Date) - [datetime]::ParseExact($value, 'MM/dd/yyyy', $null)).TotalSeconds)
            Unit 'TimeSeconds'
        }
    }
}