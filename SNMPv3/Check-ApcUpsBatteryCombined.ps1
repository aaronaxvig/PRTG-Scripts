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


Prtg {
    $SnmpInfo.OID = '1.3.6.1.4.1.318.1.1.1.2.1'
    $basicResults = Invoke-SNMPv3Walk @SnmpInfo

    if ($basicResults | Where-Object { $_.OID -eq "1.3.6.1.4.1.318.1.1.1.2.1.1.0" }) {
        Result {
            Channel "Battery status"
            $value = $basicResults | Where-Object { $_.OID -eq "1.3.6.1.4.1.318.1.1.1.2.1.1.0" } | Select-Object -ExpandProperty Value
            Value ([int]$value.ToString())
            Unit 'Custom'
            ValueLookup "oid.powernet-mib.upsbasicbattery.upsbasicbatterystatus"
        }
    }

    if ($basicResults | Where-Object { $_.OID -eq "1.3.6.1.4.1.318.1.1.1.2.1.2.0" }) {
        Result {
            Channel "Time on battery"
            $value = $basicResults | Where-Object { $_.OID -eq "1.3.6.1.4.1.318.1.1.1.2.1.2.0" } | Select-Object -ExpandProperty Value
            $parts = $value.ToString() -split ":"
            Value ([int]$parts[0] * 3600 + [int]$parts[1] * 60 + [int]$parts[2])
            Unit 'TimeSeconds'
        }
    }

    if ($basicResults | Where-Object { $_.OID -eq "1.3.6.1.4.1.318.1.1.1.2.1.3.0" }) {
        Result {
            Channel "Battery age"
            $value = $basicResults | Where-Object { $_.OID -eq "1.3.6.1.4.1.318.1.1.1.2.1.3.0" } | Select-Object -ExpandProperty Value
            Value ([int]((Get-Date) - [datetime]::ParseExact($value, 'MM/dd/yyyy', $null)).TotalSeconds)
            Unit 'TimeSeconds'
        }
    }

    $SnmpInfo.OID = '1.3.6.1.4.1.318.1.1.1.2.3'
    $highPrecisionResults = Invoke-SNMPv3Walk @SnmpInfo

    if ($highPrecisionResults | Where-Object { $_.OID -eq "1.3.6.1.4.1.318.1.1.1.2.3.1.0" }) {
        Result {
            Channel "Battery capacity"
            $value = $highPrecisionResults | Where-Object { $_.OID -eq "1.3.6.1.4.1.318.1.1.1.2.3.1.0" } | Select-Object -ExpandProperty Value
            Value ([int]$value.ToString() / 10)
            Unit 'Percent'
            Float 1
        }
    }

    if ($highPrecisionResults | Where-Object { $_.OID -eq "1.3.6.1.4.1.318.1.1.1.2.3.2.0" }) {
        Result {
            Channel "Battery temperature"
            $value = $highPrecisionResults | Where-Object { $_.OID -eq "1.3.6.1.4.1.318.1.1.1.2.3.2.0" } | Select-Object -ExpandProperty Value
            Value ([int]$value.ToString() / 10)
            Unit 'Temperature'
            Float 1
        }
    }

    if ($highPrecisionResults | Where-Object { $_.OID -eq "1.3.6.1.4.1.318.1.1.1.2.3.4.0" }) {
        Result {
            Channel "Battery voltage"
            $value = $highPrecisionResults | Where-Object { $_.OID -eq "1.3.6.1.4.1.318.1.1.1.2.3.4.0" } | Select-Object -ExpandProperty Value
            Value ([int]$value.ToString() / 10)
            Unit 'Custom'
            CustomUnit 'Volts'
            Float 1
        }
    }

    $SnmpInfo.OID = '1.3.6.1.4.1.318.1.1.1.2.2'
    $advancedResults = Invoke-SNMPv3Walk @SnmpInfo

    if ($advancedResults | Where-Object { $_.OID -eq "1.3.6.1.4.1.318.1.1.1.2.2.3.0" }) {
        Result {
            Channel "Battery run time remaining"
            $value = $advancedResults | Where-Object { $_.OID -eq "1.3.6.1.4.1.318.1.1.1.2.2.3.0" } | Select-Object -ExpandProperty Value
            $parts = $value.ToString() -split ":"
            Value ([int]$parts[0] * 3600 + [int]$parts[1] * 60 + [int]$parts[2])
            Unit 'TimeSeconds'
        }
    }

    if ($advancedResults | Where-Object { $_.OID -eq "1.3.6.1.4.1.318.1.1.1.2.2.4.0" }) {
        Result {
            Channel "Battery replace indicator"
            $value = $advancedResults | Where-Object { $_.OID -eq "1.3.6.1.4.1.318.1.1.1.2.2.4.0" } | Select-Object -ExpandProperty Value
            Value ([int]$value.ToString())
            Unit 'Custom'
            ValueLookup "oid.powernet-mib.upsadvbattery.upsadvbatteryreplaceindicator"
        }
    }

    if ($advancedResults | Where-Object { $_.OID -eq "1.3.6.1.4.1.318.1.1.1.2.2.5.0" }) {
        Result {
            Channel "Number of battery packs"
            $value = $advancedResults | Where-Object { $_.OID -eq "1.3.6.1.4.1.318.1.1.1.2.2.5.0" } | Select-Object -ExpandProperty Value
            Value ([int]$value.ToString())
            Unit 'Count'
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