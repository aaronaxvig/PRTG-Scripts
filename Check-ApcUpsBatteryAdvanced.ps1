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

$SnmpInfo.OID = '1.3.6.1.4.1.318.1.1.1.2.2'
$results = Invoke-SNMPv3Walk @SnmpInfo

Prtg {
    if ($results | Where-Object { $_.OID -eq "1.3.6.1.4.1.318.1.1.1.2.2.1.0" }) {
        Result {
            Channel "Battery capacity"
            $value = $results | Where-Object { $_.OID -eq "1.3.6.1.4.1.318.1.1.1.2.2.1.0" } | Select-Object -ExpandProperty Value
            Value ([int]$value.ToString())
            Unit 'Percent'
        }
    }

    if ($results | Where-Object { $_.OID -eq "1.3.6.1.4.1.318.1.1.1.2.2.2.0" }) {
        Result {
            Channel "Battery temperature"
            $value = $results | Where-Object { $_.OID -eq "1.3.6.1.4.1.318.1.1.1.2.2.2.0" } | Select-Object -ExpandProperty Value
            Value ([int]$value.ToString())
            Unit 'Custom'
            CustomUnit 'Celsius'
        }
    }

    if ($results | Where-Object { $_.OID -eq "1.3.6.1.4.1.318.1.1.1.2.2.3.0" }) {
        Result {
            Channel "Battery run time remaining"
            $value = $results | Where-Object { $_.OID -eq "1.3.6.1.4.1.318.1.1.1.2.2.3.0" } | Select-Object -ExpandProperty Value
            $parts = $value.ToString() -split ":"
            Value ([int]$parts[0] * 3600 + [int]$parts[1] * 60 + [int]$parts[2])
            Unit 'TimeSeconds'
        }
    }

    if ($results | Where-Object { $_.OID -eq "1.3.6.1.4.1.318.1.1.1.2.2.4.0" }) {
        Result {
            Channel "Battery replace indicator"
            $value = $results | Where-Object { $_.OID -eq "1.3.6.1.4.1.318.1.1.1.2.2.4.0" } | Select-Object -ExpandProperty Value
            Value ([int]$value.ToString())
            Unit 'Custom'
            ValueLookup "oid.powernet-mib.upsadvbattery.upsadvbatteryreplaceindicator"
        }
    }

    if ($results | Where-Object { $_.OID -eq "1.3.6.1.4.1.318.1.1.1.2.2.5.0" }) {
        Result {
            Channel "Number of battery packs"
            $value = $results | Where-Object { $_.OID -eq "1.3.6.1.4.1.318.1.1.1.2.2.5.0" } | Select-Object -ExpandProperty Value
            Value ([int]$value.ToString())
            Unit 'Count'
        }
    }

    if ($results | Where-Object { $_.OID -eq "1.3.6.1.4.1.318.1.1.1.2.2.8.0" }) {
        Result {
            Channel "Battery actual voltage"
            $value = $results | Where-Object { $_.OID -eq "1.3.6.1.4.1.318.1.1.1.2.2.8.0" } | Select-Object -ExpandProperty Value
            Value ([int]$value.ToString())
            Unit 'Custom'
            CustomUnit 'Volts'
        }
    }

    if ($results | Where-Object { $_.OID -eq "1.3.6.1.4.1.318.1.1.1.2.2.19.0" }) {
        Result {
            Channel "Battery internal SKU"
            $value = $results | Where-Object { $_.OID -eq "1.3.6.1.4.1.318.1.1.1.2.2.19.0" } | Select-Object -ExpandProperty Value
            Value ($value.ToString())
            Unit 'Custom'
            CustomUnit ''
        }
    }

    if ($results | Where-Object { $_.OID -eq "1.3.6.1.4.1.318.1.1.1.2.2.20.0" }) {
        Result {
            Channel "Battery external SKU"
            $value = $results | Where-Object { $_.OID -eq "1.3.6.1.4.1.318.1.1.1.2.2.20.0" } | Select-Object -ExpandProperty Value
            Value ($value.ToString())
            Unit 'Custom'
            CustomUnit ''
        }
    }

    if ($results | Where-Object { $_.OID -eq "1.3.6.1.4.1.318.1.1.1.2.2.21.0" }) {
        Result {
            Channel "Time to battery replace"
            $value = $results | Where-Object { $_.OID -eq "1.3.6.1.4.1.318.1.1.1.2.2.21.0" } | Select-Object -ExpandProperty Value
            Value ([int]([datetime]::ParseExact($value, 'MM/dd/yyyy', $null) - (Get-Date)).TotalSeconds)
            Unit 'TimeSeconds'
        }
    }
}