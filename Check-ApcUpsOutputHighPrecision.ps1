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

$SnmpInfo.OID = '1.3.6.1.4.1.318.1.1.1.4.3'
$results = Invoke-SNMPv3Walk @SnmpInfo

Prtg {
    Result {
        Channel "Output voltage"
        $value = $results | Where-Object { $_.OID -eq "1.3.6.1.4.1.318.1.1.1.4.3.1.0" } | Select-Object -ExpandProperty Value
        Value ([decimal]$value.ToString() / 10)
        Unit 'Custom'
        CustomUnit 'Volts AC'
        Float 1
    }
    Result {
        Channel "Output frequency"
        $value = $results | Where-Object { $_.OID -eq "1.3.6.1.4.1.318.1.1.1.4.3.2.0" } | Select-Object -ExpandProperty Value
        Value ([decimal]$value.ToString() / 10)
        Unit 'Custom'
        CustomUnit 'Hertz'
        Float 1
    }
    Result {
        Channel "Output load"
        $value = $results | Where-Object { $_.OID -eq "1.3.6.1.4.1.318.1.1.1.4.3.3.0" } | Select-Object -ExpandProperty Value
        Value ([decimal]$value.ToString() / 10)
        Unit 'Percent'
        Float 1
    }
    Result {
        Channel "Output current"
        $value = $results | Where-Object { $_.OID -eq "1.3.6.1.4.1.318.1.1.1.4.3.4.0" } | Select-Object -ExpandProperty Value
        Value ([decimal]$value.ToString() / 10)
        Unit 'Custom'
        CustomUnit 'Amps'
        Float 1
    }
    Result {
        Channel "Output efficiency"
        $value = $results | Where-Object { $_.OID -eq "1.3.6.1.4.1.318.1.1.1.4.3.5.0" } | Select-Object -ExpandProperty Value
        Value ([decimal]$value.ToString() / 10)
        Unit 'Percent'
        Float 1
    }
    Result {
        Channel "Output energy usage"
        $value = $results | Where-Object { $_.OID -eq "1.3.6.1.4.1.318.1.1.1.4.3.6.0" } | Select-Object -ExpandProperty Value
        Value ([decimal]$value.ToString() / 100)
        Unit 'Custom'
        CustomUnit 'kWh'
        Float 1
    }
}