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

$SnmpInfo.OID = '1.3.6.1.4.1.318.1.1.8.5'
$results = Invoke-SNMPv3Walk @SnmpInfo

Prtg {
    if ($results | Where-Object { $_.OID -eq "1.3.6.1.4.1.318.1.1.8.5.1.2.0" }) {
        Result {
            Channel "Selected source"
            $value = $results | Where-Object { $_.OID -eq "1.3.6.1.4.1.318.1.1.8.5.1.2.0" } | Select-Object -ExpandProperty Value
            Value ([int]$value.ToString())
            Unit 'Custom'
            ValueLookup "oid.powernet-mib.atsstatus.atsstatusselectedsource"
        }
    }

    if ($results | Where-Object { $_.OID -eq "1.3.6.1.4.1.318.1.1.8.5.1.3.0" }) {
        Result {
            Channel "Redundancy State"
            $value = $results | Where-Object { $_.OID -eq "1.3.6.1.4.1.318.1.1.8.5.1.3.0" } | Select-Object -ExpandProperty Value
            Value ([int]$value.ToString())
            Unit 'Custom'
            ValueLookup "oid.powernet-mib.atsstatus.atsstatusredundancystate"
        }
    }
    
    if ($results | Where-Object { $_.OID -eq "1.3.6.1.4.1.318.1.1.8.5.1.4.0" }) {
        Result {
            Channel "Over-current state"
            $value = $results | Where-Object { $_.OID -eq "1.3.6.1.4.1.318.1.1.8.5.1.4.0" } | Select-Object -ExpandProperty Value
            Value ([int]$value.ToString())
            Unit 'Custom'
            ValueLookup "oid.powernet-mib.atsstatus.atsstatusovercurrentstate"
        }
    }
    
    if ($results | Where-Object { $_.OID -eq "1.3.6.1.4.1.318.1.1.8.5.1.5.0" }) {
        Result {
            Channel "5V power supply status"
            $value = $results | Where-Object { $_.OID -eq "1.3.6.1.4.1.318.1.1.8.5.1.5.0" } | Select-Object -ExpandProperty Value
            Value ([int]$value.ToString())
            Unit 'Custom'
            ValueLookup "oid.powernet-mib.atsstatus.atsstatuspowersupply"
        }
    }
    
    if ($results | Where-Object { $_.OID -eq "1.3.6.1.4.1.318.1.1.8.5.1.6.0" }) {
        Result {
            Channel "24V power supply status"
            $value = $results | Where-Object { $_.OID -eq "1.3.6.1.4.1.318.1.1.8.5.1.6.0" } | Select-Object -ExpandProperty Value
            Value ([int]$value.ToString())
            Unit 'Custom'
            ValueLookup "oid.powernet-mib.atsstatus.atsstatuspowersupply"
        }
    }
}