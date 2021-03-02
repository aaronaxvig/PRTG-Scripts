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

$SnmpInfo.OID = '1.3.6.1.4.1.6574.1'
$results = Invoke-SNMPv3Walk @SnmpInfo

Prtg {
    if ($results | Where-Object { $_.OID -eq "1.3.6.1.4.1.6574.1.1.0" }) {
        Result {
            Channel "System Status"
            $value = $results | Where-Object { $_.OID -eq "1.3.6.1.4.1.6574.1.1.0" } | Select-Object -ExpandProperty Value
            Value ([int]$value.ToString())
            Unit 'Custom'
            ValueLookup "oid.synology-system-mib.synosystem.systemstatus"
        }
    }

    if ($results | Where-Object { $_.OID -eq "1.3.6.1.4.1.6574.1.2.0" }) {
        Result {
            Channel "Temperature"
            $value = $results | Where-Object { $_.OID -eq "1.3.6.1.4.1.6574.1.2.0" } | Select-Object -ExpandProperty Value
            Value ([int]$value.ToString())
            Unit 'Temperature'
        }
    }
    
    if ($results | Where-Object { $_.OID -eq "1.3.6.1.4.1.6574.1.3.0" }) {
        Result {
            Channel "Power status"
            $value = $results | Where-Object { $_.OID -eq "1.3.6.1.4.1.6574.1.3.0" } | Select-Object -ExpandProperty Value
            Value ([int]$value.ToString())
            Unit 'Custom'
            ValueLookup "oid.synology-system-mib.synosystem.powerstatus"
        }
    }
    
    if ($results | Where-Object { $_.OID -eq "1.3.6.1.4.1.6574.1.4.1.0" }) {
        Result {
            Channel "System fan status"
            $value = $results | Where-Object { $_.OID -eq "1.3.6.1.4.1.6574.1.4.1.0" } | Select-Object -ExpandProperty Value
            Value ([int]$value.ToString())
            Unit 'Custom'
            ValueLookup "oid.synology-system-mib.synosystem.systemfanstatus"
        }
    }
    
    if ($results | Where-Object { $_.OID -eq "1.3.6.1.4.1.6574.1.4.2.0" }) {
        Result {
            Channel "CPU fan status"
            $value = $results | Where-Object { $_.OID -eq "1.3.6.1.4.1.6574.1.4.2.0" } | Select-Object -ExpandProperty Value
            Value ([int]$value.ToString())
            Unit 'Custom'
            ValueLookup "oid.synology-system-mib.synosystem.cpufanstatus"
        }
    }
    
    if ($results | Where-Object { $_.OID -eq "1.3.6.1.4.1.6574.1.5.4.0" }) {
        Result {
            Channel "Upgrade available"
            $value = $results | Where-Object { $_.OID -eq "1.3.6.1.4.1.6574.1.5.4.0" } | Select-Object -ExpandProperty Value
            Value ([int]$value.ToString())
            Unit 'Custom'
            ValueLookup "oid.synology-system-mib.synosystem.upgradeavailable"
        }
    }
}