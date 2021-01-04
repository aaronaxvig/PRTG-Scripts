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

$SnmpInfo.OID = '1.3.6.1.4.1.318.1.1.1.4.2'
$results = Invoke-SNMPv3Walk @SnmpInfo

Prtg {
    if ($results | Where-Object { $_.OID -eq "1.3.6.1.4.1.318.1.1.1.4.2.1.0" }) {
        Result {
            Channel "Output voltage"
            $value = $results | Where-Object { $_.OID -eq "1.3.6.1.4.1.318.1.1.1.4.2.1.0" } | Select-Object -ExpandProperty Value
            Value ([int]$value.ToString())
            Unit 'Custom'
            CustomUnit 'Volts AC'
        }
    }

    if ($results | Where-Object { $_.OID -eq "1.3.6.1.4.1.318.1.1.1.4.2.2.0" }) {
        Result {
            Channel "Output frequency"
            $value = $results | Where-Object { $_.OID -eq "1.3.6.1.4.1.318.1.1.1.4.2.2.0" } | Select-Object -ExpandProperty Value
            Value ([int]$value.ToString())
            Unit 'Custom'
            CustomUnit 'Hertz'
        }
    }

    if ($results | Where-Object { $_.OID -eq "1.3.6.1.4.1.318.1.1.1.4.2.3.0" }) {
        Result {
            Channel "Output load"
            $value = $results | Where-Object { $_.OID -eq "1.3.6.1.4.1.318.1.1.1.4.2.3.0" } | Select-Object -ExpandProperty Value
            Value ([int]$value.ToString())
            Unit 'Percent'
        }
    }

    if ($results | Where-Object { $_.OID -eq "1.3.6.1.4.1.318.1.1.1.4.2.4.0" }) {
        Result {
            Channel "Output current"
            $value = $results | Where-Object { $_.OID -eq "1.3.6.1.4.1.318.1.1.1.4.2.4.0" } | Select-Object -ExpandProperty Value
            Value ([int]$value.ToString())
            Unit 'Custom'
            CustomUnit 'Amps'
        }
    }

    if ($results | Where-Object { $_.OID -eq "1.3.6.1.4.1.318.1.1.1.4.2.5.0" }) {
        Result {
            Channel "Output redundancy"
            $value = $results | Where-Object { $_.OID -eq "1.3.6.1.4.1.318.1.1.1.4.2.5.0" } | Select-Object -ExpandProperty Value
            Value ([int]$value.ToString())
            Unit 'Count'
        }
    }

    if ($results | Where-Object { $_.OID -eq "1.3.6.1.4.1.318.1.1.1.4.2.6.0" }) {
        Result {
            Channel "Output capacity"
            $value = $results | Where-Object { $_.OID -eq "1.3.6.1.4.1.318.1.1.1.4.2.6.0" } | Select-Object -ExpandProperty Value
            Value ([int]$value.ToString())
            Unit 'Custom'
            CustomUnit 'kVA'
        }
    }

    if ($results | Where-Object { $_.OID -eq "1.3.6.1.4.1.318.1.1.1.4.2.7.0" }) {
        Result {
            Channel "Output nominal frequency"
            $value = $results | Where-Object { $_.OID -eq "1.3.6.1.4.1.318.1.1.1.4.2.7.0" } | Select-Object -ExpandProperty Value
            Value ([int]$value.ToString())
            Unit 'Custom'
            CustomUnit 'Hertz'
        }
    }

    if ($results | Where-Object { $_.OID -eq "1.3.6.1.4.1.318.1.1.1.4.2.8.0" }) {
        Result {
            Channel "Output active power"
            $value = $results | Where-Object { $_.OID -eq "1.3.6.1.4.1.318.1.1.1.4.2.8.0" } | Select-Object -ExpandProperty Value
            Value ([int]$value.ToString())
            Unit 'Custom'
            CustomUnit 'Watts'
        }
    }

    if ($results | Where-Object { $_.OID -eq "1.3.6.1.4.1.318.1.1.1.4.2.9.0" }) {
        Result {
            Channel "Output apparent power"
            $value = $results | Where-Object { $_.OID -eq "1.3.6.1.4.1.318.1.1.1.4.2.9.0" } | Select-Object -ExpandProperty Value
            Value ([int]$value.ToString())
            Unit 'Custom'
            CustomUnit 'VA'
        }
    }
}