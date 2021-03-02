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

$SnmpInfo.OID = '1.3.6.1.4.1.318.1.1.26.7.0'
$results = Invoke-SNMpv3Get @SnmpInfo
$bankCount = [int]$results.Value.ToString()

$SnmpInfo.OID = '1.3.6.1.4.1.318.1.1.26.8.3.1'
$results = Invoke-SNMPv3Walk @SnmpInfo

Prtg {
    for ($bank = 1; $bank -le $bankCount; $bank++) {
        if ($results | Where-Object { $_.OID -eq "1.3.6.1.4.1.318.1.1.26.8.3.1.5.$bank" }) {
            Result {
                Channel "Bank $bank current"
                $value = $results | Where-Object { $_.OID -eq "1.3.6.1.4.1.318.1.1.26.8.3.1.5.$bank" } | Select-Object -ExpandProperty Value
                Value ([decimal]$value.ToString() / 10)
                Unit 'Custom'
                CustomUnit 'Amps'
                Float 1
            }
        }
        if ($results | Where-Object { $_.OID -eq "1.3.6.1.4.1.318.1.1.26.8.3.1.6.$bank" }) {
            Result {
                Channel "Bank $bank peak current"
                $value = $results | Where-Object { $_.OID -eq "1.3.6.1.4.1.318.1.1.26.8.3.1.6.$bank" } | Select-Object -ExpandProperty Value
                Value ([decimal]$value.ToString() / 10)
                Unit 'Custom'
                CustomUnit 'Amps'
                Float 1
            }
        }
        if ($results | Where-Object { $_.OID -eq "1.3.6.1.4.1.318.1.1.26.8.3.1.7.$bank" }) {
            Result {
                Channel "Bank $bank time since peak current"
                $value = $results | Where-Object { $_.OID -eq "1.3.6.1.4.1.318.1.1.26.8.3.1.7.$bank" } | Select-Object -ExpandProperty Value
                Value ([int]((Get-Date) - [datetime]::ParseExact($value, 'MM/dd/yyyy HH:mm:ss', $null)).TotalSeconds)
                Unit 'TimeSeconds'
            }
        }
        if ($results | Where-Object { $_.OID -eq "1.3.6.1.4.1.318.1.1.26.8.3.1.8.$bank" }) {
            Result {
                Channel "Bank $bank time since peak current reset"
                $value = $results | Where-Object { $_.OID -eq "1.3.6.1.4.1.318.1.1.26.8.3.1.8.$bank" } | Select-Object -ExpandProperty Value
                Value ([int]((Get-Date) - [datetime]::ParseExact($value, 'MM/dd/yyyy HH:mm:ss', $null)).TotalSeconds)
                Unit 'TimeSeconds'
            }
        }
    }
}