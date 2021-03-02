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

$SnmpInfo.OID = '1.3.6.1.4.1.318.1.1.1.2.3'
$results = Invoke-SNMPv3Walk @SnmpInfo

Prtg {
    if ($results | Where-Object { $_.OID -eq "1.3.6.1.4.1.318.1.1.1.2.3.1.0" }) {
        Result {
            Channel "Battery capacity"
            $value = $results | Where-Object { $_.OID -eq "1.3.6.1.4.1.318.1.1.1.2.3.1.0" } | Select-Object -ExpandProperty Value
            Value ([int]$value.ToString() / 10)
            Unit 'Percent'
            Float 1
        }
    }

    if ($results | Where-Object { $_.OID -eq "1.3.6.1.4.1.318.1.1.1.2.3.2.0" }) {
        Result {
            Channel "Battery temperature"
            $value = $results | Where-Object { $_.OID -eq "1.3.6.1.4.1.318.1.1.1.2.3.2.0" } | Select-Object -ExpandProperty Value
            Value ([int]$value.ToString() / 10)
            Unit 'Temperature'
            Float 1
        }
    }

    if ($results | Where-Object { $_.OID -eq "1.3.6.1.4.1.318.1.1.1.2.3.4.0" }) {
        Result {
            Channel "Battery actual voltage"
            $value = $results | Where-Object { $_.OID -eq "1.3.6.1.4.1.318.1.1.1.2.3.4.0" } | Select-Object -ExpandProperty Value
            Value ([int]$value.ToString() / 10)
            Unit 'Custom'
            CustomUnit 'Volts'
            Float 1
        }
    }
}