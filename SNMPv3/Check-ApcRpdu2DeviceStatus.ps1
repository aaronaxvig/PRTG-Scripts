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

$SnmpInfo.OID = '1.3.6.1.4.1.318.1.1.26.3.0'
$results = Invoke-SNMpv3Get @SnmpInfo
$deviceCount = [int]$results.Value.ToString()

$SnmpInfo.OID = '1.3.6.1.4.1.318.1.1.26.4.3.1'
$results = Invoke-SNMPv3Walk @SnmpInfo

Prtg {
    for ($device = 1; $device -le $deviceCount; $device++) {
        if ($results | Where-Object { $_.OID -eq "1.3.6.1.4.1.318.1.1.26.4.3.1.4.$device" }) {
            Result {
                Channel "Device $device load state"
                $value = $results | Where-Object { $_.OID -eq "1.3.6.1.4.1.318.1.1.26.4.3.1.4.$device" } | Select-Object -ExpandProperty Value
                Value ([int]$value.ToString())
                Unit 'Custom'
                ValueLookup "oid.powernet-mib.rpdu2devicestatus.rpdu2devicestatusloadstate"
            }
        }
        if ($results | Where-Object { $_.OID -eq "1.3.6.1.4.1.318.1.1.26.4.3.1.5.$device" }) {
            Result {
                Channel "Device $device power"
                $value = $results | Where-Object { $_.OID -eq "1.3.6.1.4.1.318.1.1.26.4.3.1.5.$device" } | Select-Object -ExpandProperty Value
                Value ([decimal]$value.ToString() / 100)
                Unit 'Custom'
                CustomUnit 'Kilowatts'
                Float 1
            }
        }
        if ($results | Where-Object { $_.OID -eq "1.3.6.1.4.1.318.1.1.26.4.3.1.6.$device" }) {
            Result {
                Channel "Device $device peak power"
                $value = $results | Where-Object { $_.OID -eq "1.3.6.1.4.1.318.1.1.26.4.3.1.6.$device" } | Select-Object -ExpandProperty Value
                Value ([decimal]$value.ToString() / 100)
                Unit 'Custom'
                CustomUnit 'Kilowatts'
                Float 1
            }
        }
        if ($results | Where-Object { $_.OID -eq "1.3.6.1.4.1.318.1.1.26.4.3.1.7.$device" }) {
            Result {
                Channel "Device $device time since peak power"
                $value = $results | Where-Object { $_.OID -eq "1.3.6.1.4.1.318.1.1.26.4.3.1.7.$device" } | Select-Object -ExpandProperty Value
                Value ([int]((Get-Date) - [datetime]::ParseExact($value, 'MM/dd/yyyy HH:mm:ss', $null)).TotalSeconds)
                Unit 'TimeSeconds'
            }
        }
        if ($results | Where-Object { $_.OID -eq "1.3.6.1.4.1.318.1.1.26.4.3.1.8.$device" }) {
            Result {
                Channel "Device $device time since peak power reset"
                $value = $results | Where-Object { $_.OID -eq "1.3.6.1.4.1.318.1.1.26.4.3.1.8.$device" } | Select-Object -ExpandProperty Value
                Value ([int]((Get-Date) - [datetime]::ParseExact($value, 'MM/dd/yyyy HH:mm:ss', $null)).TotalSeconds)
                Unit 'TimeSeconds'
            }
        }
        if ($results | Where-Object { $_.OID -eq "1.3.6.1.4.1.318.1.1.26.4.3.1.9.$device" }) {
            Result {
                Channel "Device $device energy used"
                $value = $results | Where-Object { $_.OID -eq "1.3.6.1.4.1.318.1.1.26.4.3.1.9.$device" } | Select-Object -ExpandProperty Value
                Value ([decimal]$value.ToString() / 10)
                Unit 'Custom'
                CustomUnit 'Kilowatt-hours'
                Float 1
            }
        }
        if ($results | Where-Object { $_.OID -eq "1.3.6.1.4.1.318.1.1.26.4.3.1.10.$device" }) {
            Result {
                Channel "Device $device time since energy used reset"
                $value = $results | Where-Object { $_.OID -eq "1.3.6.1.4.1.318.1.1.26.4.3.1.10.$device" } | Select-Object -ExpandProperty Value
                Value ([int]((Get-Date) - [datetime]::ParseExact($value, 'MM/dd/yyyy HH:mm:ss', $null)).TotalSeconds)
                Unit 'TimeSeconds'
            }
        }
        if ($results | Where-Object { $_.OID -eq "1.3.6.1.4.1.318.1.1.26.4.3.1.12.$device" }) {
            Result {
                Channel "Device $device power supply alarm"
                $value = $results | Where-Object { $_.OID -eq "1.3.6.1.4.1.318.1.1.26.4.3.1.12.$device" } | Select-Object -ExpandProperty Value
                Value ([int]$value.ToString())
                Unit 'Custom'
                ValueLookup "oid.powernet-mib.rpdu2devicestatus.rpdu2devicestatuspowersupplyalarm"
            }
        }
        if ($results | Where-Object { $_.OID -eq "1.3.6.1.4.1.318.1.1.26.4.3.1.13.$device" }) {
            Result {
                Channel "Device $device power supply 1 status"
                $value = $results | Where-Object { $_.OID -eq "1.3.6.1.4.1.318.1.1.26.4.3.1.13.$device" } | Select-Object -ExpandProperty Value
                Value ([int]$value.ToString())
                Unit 'Custom'
                ValueLookup "oid.powernet-mib.rpdu2devicestatus.rpdu2devicestatuspowersupplystatus"
            }
        }
        if ($results | Where-Object { $_.OID -eq "1.3.6.1.4.1.318.1.1.26.4.3.1.14.$device" }) {
            Result {
                Channel "Device $device power supply 2 status"
                $value = $results | Where-Object { $_.OID -eq "1.3.6.1.4.1.318.1.1.26.4.3.1.14.$device" } | Select-Object -ExpandProperty Value
                Value ([int]$value.ToString())
                Unit 'Custom'
                ValueLookup "oid.powernet-mib.rpdu2devicestatus.rpdu2devicestatuspowersupplystatus"
            }
        }
        if ($results | Where-Object { $_.OID -eq "1.3.6.1.4.1.318.1.1.26.4.3.1.16.$device" }) {
            Result {
                Channel "Device $device apparent power"
                $value = $results | Where-Object { $_.OID -eq "1.3.6.1.4.1.318.1.1.26.4.3.1.16.$device" } | Select-Object -ExpandProperty Value
                Value ([decimal]$value.ToString() / 100)
                Unit 'Custom'
                CustomUnit 'KiloVolt-Amps'
                Float 1
            }
        }
        if ($results | Where-Object { $_.OID -eq "1.3.6.1.4.1.318.1.1.26.4.3.1.17.$device" }) {
            Result {
                Channel "Device $device power factor"
                $value = $results | Where-Object { $_.OID -eq "1.3.6.1.4.1.318.1.1.26.4.3.1.17.$device" } | Select-Object -ExpandProperty Value
                Value ([decimal]$value.ToString() / 100)
                Unit 'Custom'
                CustomUnit ''
                Float 1
            }
        }
    }
}