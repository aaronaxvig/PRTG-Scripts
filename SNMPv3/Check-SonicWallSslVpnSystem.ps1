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

$SnmpInfo.OID = '1.3.6.1.4.1.8741.6'
$results = Invoke-SNMPv3Walk @SnmpInfo

Prtg {
    if ($results | Where-Object { $_.OID -eq "1.3.6.1.4.1.8741.6.2.1.3.0" }) {
        Result {
            Channel "CPU utilization"
            $value = $results | Where-Object { $_.OID -eq "1.3.6.1.4.1.8741.6.2.1.3.0" } | Select-Object -ExpandProperty Value
            Value ([int]$value.ToString())
            Unit 'Percent'
        }
    }

    if ($results | Where-Object { $_.OID -eq "1.3.6.1.4.1.8741.6.2.1.5.0" }) {
        Result {
            Channel "Memory utilization"
            $value = $results | Where-Object { $_.OID -eq "1.3.6.1.4.1.8741.6.2.1.5.0" } | Select-Object -ExpandProperty Value
            Value ([int]$value.ToString())
            Unit 'Percent'
        }
    }
    
    if ($results | Where-Object { $_.OID -eq "1.3.6.1.4.1.8741.6.2.1.8.0" }) {
        Result {
            Channel "Active users"
            $value = $results | Where-Object { $_.OID -eq "1.3.6.1.4.1.8741.6.2.1.8.0" } | Select-Object -ExpandProperty Value
            Value ([int]$value.ToString())
            Unit 'Count'
        }
    }
    
    if ($results | Where-Object { $_.OID -eq "1.3.6.1.4.1.8741.6.2.1.9.0" }) {
        Result {
            Channel "Licenses in use"
            $value = $results | Where-Object { $_.OID -eq "1.3.6.1.4.1.8741.6.2.1.9.0" } | Select-Object -ExpandProperty Value
            Value ([int]$value.ToString())
            Unit 'Count'
        }
    }
    
    if ($results | Where-Object { $_.OID -eq "1.3.6.1.4.1.8741.6.2.1.10.0" }) {
        Result {
            Channel "Active NetExtender connections"
            $value = $results | Where-Object { $_.OID -eq "1.3.6.1.4.1.8741.6.2.1.10.0" } | Select-Object -ExpandProperty Value
            Value ([int]$value.ToString())
            Unit 'Count'
        }
    }
    
    if ($results | Where-Object { $_.OID -eq "1.3.6.1.4.1.8741.6.2.1.11.0" }) {
        Result {
            Channel "Active Virtual Assist technicians"
            $value = $results | Where-Object { $_.OID -eq "1.3.6.1.4.1.8741.6.2.1.11.0" } | Select-Object -ExpandProperty Value
            Value ([int]$value.ToString())
            Unit 'Count'
        }
    }
    
    if ($results | Where-Object { $_.OID -eq "1.3.6.1.4.1.8741.6.3.1.1.0" }) {
        $value = $results | Where-Object { $_.OID -eq "1.3.6.1.4.1.8741.6.3.1.1.0" } | Select-Object -ExpandProperty Value
        # Example value: "25 Users"
        $owned = ([int]($value.ToString().Split(" ")[0]))

        Result {
            Channel "Licenses owned"
            Value $owned
            Unit 'Count'
        }

        # Grab the number of licenses in use again and use it with licenses owned to calculate percentage in use.
        if ($results | Where-Object { $_.OID -eq "1.3.6.1.4.1.8741.6.2.1.9.0" }) {
            $value = $results | Where-Object { $_.OID -eq "1.3.6.1.4.1.8741.6.2.1.9.0" } | Select-Object -ExpandProperty Value
            $used = [int]$value.ToString()

            Result {
                Channel "Licenses utilization"
                Value ([int](($used / $owned) * 100))
                Unit 'Percent'
                LimitMaxWarning 90
            }
        }
    }
}