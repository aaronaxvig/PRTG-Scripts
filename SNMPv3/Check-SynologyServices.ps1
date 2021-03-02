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

$SnmpInfo.OID = '1.3.6.1.4.1.6574.6'
$results = Invoke-SNMPv3Walk @SnmpInfo

Prtg {
    $serviceCount = 1

    while ($results | Where-Object { $_.OID -eq "1.3.6.1.4.1.6574.6.1.1.1.$serviceCount" }) {
        $serviceName = ""

        if ($results | Where-Object { $_.OID -eq "1.3.6.1.4.1.6574.6.1.1.2.$serviceCount" }) {
            $serviceName = ($results | Where-Object { $_.OID -eq "1.3.6.1.4.1.6574.6.1.1.2.$serviceCount" } | Select-Object -ExpandProperty Value).ToString()
        }

        if ($results | Where-Object { $_.OID -eq "1.3.6.1.4.1.6574.6.1.1.3.$serviceCount" }) {
            Result {
                Channel "$serviceName service"
                $value = $results | Where-Object { $_.OID -eq "1.3.6.1.4.1.6574.6.1.1.3.$serviceCount" } | Select-Object -ExpandProperty Value
                Value ([int]$value.ToString())
                Unit "Custom"
                CustomUnit "Users"
            }
        }

        $serviceCount++
    }
}