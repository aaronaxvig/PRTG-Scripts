#Requires -Modules PrtgXml
# Install-Module PrtgXml
# https://www.powershellgallery.com/packages/PrtgXml
# https://github.com/lordmilko/PrtgXml

Param(
    [Parameter(Mandatory=$true)]
    [string]
    $Target,

    [Parameter(Mandatory=$false)]
    [guid]
    $JobGuid
)

Import-Module 'C:\Program Files\Veeam\Backup365\Veeam.Archiver.PowerShell\Veeam.Archiver.PowerShell.psd1'
Connect-VBOServer -Server $Target

$job = $null
if ($JobGuid) {
    $job = Get-VBOJob -Id $JobGuid
}
else {
    $jobs = Get-VBOJob
    $job = $jobs[0]
}

Prtg {
    Result {
        Channel "Last status"
        Value $job.LastStatus.Value__
        Unit 'Custom'
        ValueLookup "veeam-archiver-powershell-model-enums-vbojobstatus"
    }
}

Disconnect-VBOServer