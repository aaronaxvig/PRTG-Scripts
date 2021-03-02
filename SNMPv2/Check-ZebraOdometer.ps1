#Requires -Modules PoshSNMP
# Install-Module PoshSNMP
# https://www.powershellgallery.com/packages/PoshSNMP/0.2.3

#Requires -Modules PrtgXml
# Install-Module PrtgXml
# https://www.powershellgallery.com/packages/PrtgXml
# https://github.com/lordmilko/PrtgXml

[System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingPlainTextForPassword", "SnmpV2CredentialsFile")]
Param(
    [Parameter(Mandatory=$true)]
    [string]
    $Target,

    [Parameter(Mandatory=$false)]
    [string]
    $SnmpV2CredentialsFile = 'SnmpV2Credentials.ps1'
)

$path = Join-Path $PSScriptRoot $SnmpV2CredentialsFile
. $path

$SnmpInfo.ComputerName = $Target

$SnmpInfo.ObjectIdentifier = '1.3.6.1.4.1.10642.3.1'
$results = Invoke-SnmpWalk @SnmpInfo

Prtg {
    if ($results | Where-Object { $_.OID -eq "1.3.6.1.4.1.10642.3.1.4.0" }) {
        Result {
            Channel "Length since head replaced"
            $value = $results | Where-Object { $_.OID -eq "1.3.6.1.4.1.10642.3.1.4.0" } | Select-Object -ExpandProperty Data
            Value ([int]$value.ToString() / 100)
            Unit 'Custom'
            CustomUnit 'meters'
            Float 1
        }
    }
    
    if ($results | Where-Object { $_.OID -eq "1.3.6.1.4.1.10642.3.1.3.0" }) {
        Result {
            Channel "Length since head cleaned"
            $value = $results | Where-Object { $_.OID -eq "1.3.6.1.4.1.10642.3.1.3.0" } | Select-Object -ExpandProperty Data
            Value ([int]$value.ToString() / 100)
            Unit 'Custom'
            CustomUnit 'meters'
            Float 1

        }
    }
    if ($results | Where-Object { $_.OID -eq "1.3.6.1.4.1.10642.3.1.7.0" }) {
        Result {
            Channel "Labels printed"
            $value = $results | Where-Object { $_.OID -eq "1.3.6.1.4.1.10642.3.1.7.0" } | Select-Object -ExpandProperty Data
            Value ([int]$value.ToString())
            Unit 'Count'
        }
    }

    if ($results | Where-Object { $_.OID -eq "1.3.6.1.4.1.10642.3.1.8.0" }) {
        Result {
            Channel "Length printed"
            $value = $results | Where-Object { $_.OID -eq "1.3.6.1.4.1.10642.3.1.8.0" } | Select-Object -ExpandProperty Data
            Value ([int]$value.ToString() / 100)
            Unit 'Custom'
            CustomUnit 'meters'
            Float 1
        }
    }

    if ($results | Where-Object { $_.OID -eq "1.3.6.1.4.1.10642.3.1.9.0" }) {
        Result {
            Channel "Latch open count"
            $value = $results | Where-Object { $_.OID -eq "1.3.6.1.4.1.10642.3.1.9.0" } | Select-Object -ExpandProperty Data
            Value ([int]$value.ToString())
            Unit 'Count'
        }
    }

    if ($results | Where-Object { $_.OID -eq "1.3.6.1.4.1.10642.3.1.11.0" }) {
        $value = $results | Where-Object { $_.OID -eq "1.3.6.1.4.1.10642.3.1.11.0" } | Select-Object -ExpandProperty Data
        $labelsPassed = [int]$value.ToString()

        if ($labelsPassed -gt 0) {
            Result {
                Channel "Labels passed"
                Value ($labelsPassed)
                Unit 'Count'
            }
        }

        if ($results | Where-Object { $_.OID -eq "1.3.6.1.4.1.10642.3.1.7.0" }) {
            $value = $results | Where-Object { $_.OID -eq "1.3.6.1.4.1.10642.3.1.7.0" } | Select-Object -ExpandProperty Data
            $labelsPrinted = [int]$value.ToString()
            $labelsUnprinted = $labelsPassed - $labelsPrinted

            if ($labelsUnprinted -gt 0) {
                Result {
                    Channel "Unprinted labels"
                    Value ($labelsUnprinted)
                    Unit 'Count'
                }
            }
        }
    }

    if ($results | Where-Object { $_.OID -eq "1.3.6.1.4.1.10642.3.1.14.0" }) {
        $value = $results | Where-Object { $_.OID -eq "1.3.6.1.4.1.10642.3.1.14.0" } | Select-Object -ExpandProperty Data
        $rfidValid = [int]$value.ToString()
        
        if ($rfidValid -gt 0) {
            Result {
                Channel "RFID valid"
                Value $rfidValid
                Unit 'Count'
            }
        }
    }

    if ($results | Where-Object { $_.OID -eq "1.3.6.1.4.1.10642.3.1.15.0" }) {
        $value = $results | Where-Object { $_.OID -eq "1.3.6.1.4.1.10642.3.1.15.0" } | Select-Object -ExpandProperty Data
        $rfidVoid = [int]$value.ToString()
        
        if ($rfidVoid -gt 0) {
            Result {
                Channel "RFID void"
                Value $rfidVoid
                Unit 'Count'
            }
        }
    }

    if ($results | Where-Object { $_.OID -eq "1.3.6.1.4.1.10642.3.1.16.0" }) {
        $value = $results | Where-Object { $_.OID -eq "1.3.6.1.4.1.10642.3.1.16.0" } | Select-Object -ExpandProperty Data
        $cuts = [int]$value.ToString()
        
        if ($cuts -gt 0) {
            Result {
                Channel "Cuts"
                Value $cuts
                Unit 'Count'
            }
        }
    }

    if ($results | Where-Object { $_.OID -eq "1.3.6.1.4.1.10642.3.1.18.0" }) {
        $value = $results | Where-Object { $_.OID -eq "1.3.6.1.4.1.10642.3.1.18.0" } | Select-Object -ExpandProperty Data
        $ribbonUse = [int]$value.ToString()
        
        if ($ribbonUse -gt 0) {
            Result {
                Channel "Ribbon use"
                Value ($ribbonUse / 100)
                Unit 'Custom'
                CustomUnit 'meters'
                Float 1
            }
        }
    }

    if ($results | Where-Object { $_.OID -eq "1.3.6.1.4.1.10642.3.1.19.0" }) {
        $value = $results | Where-Object { $_.OID -eq "1.3.6.1.4.1.10642.3.1.19.0" } | Select-Object -ExpandProperty Data
        $mediaUse = [int]$value.ToString()
        
        if ($mediaUse -gt 0) {
            Result {
                Channel "Media use"
                Value ($mediaUse / 100)
                Unit 'Custom'
                CustomUnit 'meters'
                Float 1
            }
        }
    }
}