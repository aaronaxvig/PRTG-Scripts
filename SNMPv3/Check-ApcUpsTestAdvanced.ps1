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

$SnmpInfo.OID = '1.3.6.1.4.1.318.1.1.1.7.2'
$results = Invoke-SNMPv3Walk @SnmpInfo

Prtg {
    if ($results | Where-Object { $_.OID -eq "1.3.6.1.4.1.318.1.1.1.7.2.1.0" }) {
        Result {
            Channel "Diagnostic schedule"
            $value = $results | Where-Object { $_.OID -eq "1.3.6.1.4.1.318.1.1.1.7.2.1.0" } | Select-Object -ExpandProperty Value
            Value ([int]$value.ToString())
            Unit 'Custom'
            ValueLookup "oid.powernet-mib.upsadvtest.upsadvtestdiagnosticschedule"
        }
    }

    if ($results | Where-Object { $_.OID -eq "1.3.6.1.4.1.318.1.1.1.7.2.3.0" }) {
        Result {
            Channel "Diagnostics results"
            $value = $results | Where-Object { $_.OID -eq "1.3.6.1.4.1.318.1.1.1.7.2.3.0" } | Select-Object -ExpandProperty Value
            Value ([int]$value.ToString())
            Unit 'Custom'
            ValueLookup "oid.powernet-mib.upsadvtest.upsadvtestdiagnosticsresults"
        }
    }

    if ($results | Where-Object { $_.OID -eq "1.3.6.1.4.1.318.1.1.1.7.2.4.0" }) {
        Result {
            Channel "Time since last diagnostics"
            $value = $results | Where-Object { $_.OID -eq "1.3.6.1.4.1.318.1.1.1.7.2.4.0" } | Select-Object -ExpandProperty Value
            Value ([int]((Get-Date) - [datetime]::ParseExact($value, 'MM/dd/yyyy', $null)).TotalSeconds)
            Unit 'TimeSeconds'
        }
    }

    if ($results | Where-Object { $_.OID -eq "1.3.6.1.4.1.318.1.1.1.7.2.6.0" }) {
        Result {
            Channel "Calibration results"
            $value = $results | Where-Object { $_.OID -eq "1.3.6.1.4.1.318.1.1.1.7.2.6.0" } | Select-Object -ExpandProperty Value
            Value ([int]$value.ToString())
            Unit 'Custom'
            ValueLookup "oid.powernet-mib.upsadvtest.upsadvtestcalibrationresults"
        }
    }

    if ($results | Where-Object { $_.OID -eq "1.3.6.1.4.1.318.1.1.1.7.2.7.0" }) {
        Result {
            Channel "Time since last calibration"
            $value = $results | Where-Object { $_.OID -eq "1.3.6.1.4.1.318.1.1.1.7.2.7.0" } | Select-Object -ExpandProperty Value
            Value ([int]((Get-Date) - [datetime]::ParseExact($value, 'MM/dd/yyyy', $null)).TotalSeconds)
            Unit 'TimeSeconds'
        }
    }
}