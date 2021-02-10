Param(
    [Parameter(Mandatory=$true)]
    [string]
    $Target,

    [Parameter(Mandatory=$false)]
    [guid]
    $JobGuid
)

if ($JobGuid) {
    &"$env:WINDIR\sysnative\windowspowershell\v1.0\powershell.exe" -file "C:\Program Files (x86)\PRTG Network Monitor\Custom Sensors\EXEXML\Check-VeeamBackupForOffice365Job.ps1" -Target $Target -JobGuid $JobGuid
}
else {
    &"$env:WINDIR\sysnative\windowspowershell\v1.0\powershell.exe" -file "C:\Program Files (x86)\PRTG Network Monitor\Custom Sensors\EXEXML\Check-VeeamBackupForOffice365Job.ps1" -Target $Target
}