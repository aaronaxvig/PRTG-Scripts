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

$SnmpInfo.OID = '1.3.6.1.4.1.318.1.1.1.3.3'
$inputResults = Invoke-SNMPv3Walk @SnmpInfo

Prtg {
    $SnmpInfo.OID = '1.3.6.1.4.1.318.1.1.1.3.3'
    $inputResults = Invoke-SNMPv3Walk @SnmpInfo

    if ($inputResults | Where-Object { $_.OID -eq "1.3.6.1.4.1.318.1.1.1.3.3.1.0" }) {
        Result {
            Channel "Input line voltage"
            $value = $inputResults | Where-Object { $_.OID -eq "1.3.6.1.4.1.318.1.1.1.3.3.1.0" } | Select-Object -ExpandProperty Value
            Value ([decimal]$value.ToString() / 10)
            Unit 'Custom'
            CustomUnit 'Volts AC'
            Float 1
        }
    }

    if ($inputResults | Where-Object { $_.OID -eq "1.3.6.1.4.1.318.1.1.1.3.3.2.0" }) {
        Result {
            Channel "Maximum input line voltage (1 min)"
            $value = $inputResults | Where-Object { $_.OID -eq "1.3.6.1.4.1.318.1.1.1.3.3.2.0" } | Select-Object -ExpandProperty Value
            Value ([decimal]$value.ToString() / 10)
            Unit 'Custom'
            CustomUnit 'Volts AC'
            Float 1
        }
    }

    if ($inputResults | Where-Object { $_.OID -eq "1.3.6.1.4.1.318.1.1.1.3.3.3.0" }) {
        Result {
            Channel "Minimum input line voltage (1 min)"
            $value = $inputResults | Where-Object { $_.OID -eq "1.3.6.1.4.1.318.1.1.1.3.3.3.0" } | Select-Object -ExpandProperty Value
            Value ([decimal]$value.ToString() / 10)
            Unit 'Custom'
            CustomUnit 'Volts AC'
            Float 1
        }
    }

    if ($inputResults | Where-Object { $_.OID -eq "1.3.6.1.4.1.318.1.1.1.3.3.4.0" }) {
        Result {
            Channel "Input frequency"
            $value = $inputResults | Where-Object { $_.OID -eq "1.3.6.1.4.1.318.1.1.1.3.3.4.0" } | Select-Object -ExpandProperty Value
            Value ([decimal]$value.ToString() / 10)
            Unit 'Custom'
            CustomUnit 'Hertz'
            Float 1
        }
    }

    $SnmpInfo.OID = '1.3.6.1.4.1.318.1.1.1.4.2'
    $outputAdvancedResults = Invoke-SNMPv3Walk @SnmpInfo

    if ($outputAdvancedResults | Where-Object { $_.OID -eq "1.3.6.1.4.1.318.1.1.1.4.2.5.0" }) {
        Result {
            Channel "Output redundancy"
            $value = $outputAdvancedResults | Where-Object { $_.OID -eq "1.3.6.1.4.1.318.1.1.1.4.2.5.0" } | Select-Object -ExpandProperty Value
            Value ([int]$value.ToString())
            Unit 'Count'
        }
    }

    if ($outputAdvancedResults | Where-Object { $_.OID -eq "1.3.6.1.4.1.318.1.1.1.4.2.6.0" }) {
        Result {
            Channel "Output capacity"
            $value = $outputAdvancedResults | Where-Object { $_.OID -eq "1.3.6.1.4.1.318.1.1.1.4.2.6.0" } | Select-Object -ExpandProperty Value
            Value ([int]$value.ToString())
            Unit 'Custom'
            CustomUnit 'kVA'
        }
    }

    if ($outputAdvancedResults | Where-Object { $_.OID -eq "1.3.6.1.4.1.318.1.1.1.4.2.7.0" }) {
        Result {
            Channel "Output nominal frequency"
            $value = $outputAdvancedResults | Where-Object { $_.OID -eq "1.3.6.1.4.1.318.1.1.1.4.2.7.0" } | Select-Object -ExpandProperty Value
            Value ([int]$value.ToString())
            Unit 'Custom'
            CustomUnit 'Hertz'
        }
    }

    if ($outputAdvancedResults | Where-Object { $_.OID -eq "1.3.6.1.4.1.318.1.1.1.4.2.8.0" }) {
        Result {
            Channel "Output active power"
            $value = $outputAdvancedResults | Where-Object { $_.OID -eq "1.3.6.1.4.1.318.1.1.1.4.2.8.0" } | Select-Object -ExpandProperty Value
            Value ([int]$value.ToString())
            Unit 'Custom'
            CustomUnit 'Watts'
        }
    }

    if ($outputAdvancedResults | Where-Object { $_.OID -eq "1.3.6.1.4.1.318.1.1.1.4.2.9.0" }) {
        Result {
            Channel "Output apparent power"
            $value = $outputAdvancedResults | Where-Object { $_.OID -eq "1.3.6.1.4.1.318.1.1.1.4.2.9.0" } | Select-Object -ExpandProperty Value
            Value ([int]$value.ToString())
            Unit 'Custom'
            CustomUnit 'VA'
        }
    }

    $SnmpInfo.OID = '1.3.6.1.4.1.318.1.1.1.4.3'
    $outputHighPrecisionResults = Invoke-SNMPv3Walk @SnmpInfo

    if ($outputHighPrecisionResults | Where-Object { $_.OID -eq "1.3.6.1.4.1.318.1.1.1.4.3.1.0" }) {
        Result {
            Channel "Output voltage"
            $value = $outputHighPrecisionResults | Where-Object { $_.OID -eq "1.3.6.1.4.1.318.1.1.1.4.3.1.0" } | Select-Object -ExpandProperty Value
            Value ([decimal]$value.ToString() / 10)
            Unit 'Custom'
            CustomUnit 'Volts AC'
            Float 1
        }
    }
    if ($outputHighPrecisionResults | Where-Object { $_.OID -eq "1.3.6.1.4.1.318.1.1.1.4.3.2.0" }) {
        Result {
            Channel "Output frequency"
            $value = $outputHighPrecisionResults | Where-Object { $_.OID -eq "1.3.6.1.4.1.318.1.1.1.4.3.2.0" } | Select-Object -ExpandProperty Value
            Value ([decimal]$value.ToString() / 10)
            Unit 'Custom'
            CustomUnit 'Hertz'
            Float 1
        }
    }
    if ($outputHighPrecisionResults | Where-Object { $_.OID -eq "1.3.6.1.4.1.318.1.1.1.4.3.3.0" }) {
        Result {
            Channel "Output load"
            $value = $outputHighPrecisionResults | Where-Object { $_.OID -eq "1.3.6.1.4.1.318.1.1.1.4.3.3.0" } | Select-Object -ExpandProperty Value
            Value ([decimal]$value.ToString() / 10)
            Unit 'Percent'
            Float 1
        }
    }
    if ($outputHighPrecisionResults | Where-Object { $_.OID -eq "1.3.6.1.4.1.318.1.1.1.4.3.4.0" }) {
        Result {
            Channel "Output current"
            $value = $outputHighPrecisionResults | Where-Object { $_.OID -eq "1.3.6.1.4.1.318.1.1.1.4.3.4.0" } | Select-Object -ExpandProperty Value
            Value ([decimal]$value.ToString() / 10)
            Unit 'Custom'
            CustomUnit 'Amps'
            Float 1
        }
    }
    if ($outputHighPrecisionResults | Where-Object { $_.OID -eq "1.3.6.1.4.1.318.1.1.1.4.3.5.0" }) {
        Result {
            Channel "Output efficiency"
            $value = $outputHighPrecisionResults | Where-Object { $_.OID -eq "1.3.6.1.4.1.318.1.1.1.4.3.5.0" } | Select-Object -ExpandProperty Value
            Value ([decimal]$value.ToString() / 10)
            Unit 'Percent'
            Float 1
        }
    }
    if ($outputHighPrecisionResults | Where-Object { $_.OID -eq "1.3.6.1.4.1.318.1.1.1.4.3.6.0" }) {
        Result {
            Channel "Output energy usage"
            $value = $outputHighPrecisionResults | Where-Object { $_.OID -eq "1.3.6.1.4.1.318.1.1.1.4.3.6.0" } | Select-Object -ExpandProperty Value
            Value ([decimal]$value.ToString() / 100)
            Unit 'Custom'
            CustomUnit 'kWh'
            Float 1
        }
    }
}