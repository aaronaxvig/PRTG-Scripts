# Install
* On your PRTG server, install the PowerShell component from the Veeam Backup for Microsoft Office 365 installer.  This should make the file `C:\Program Files\Veeam\Backup365\Veeam.Archiver.PowerShell\Veeam.Archiver.PowerShell.psd1` and its friends where they need to be.
* Put `Check-VeeamBackupForOffice365Job.ps1` and `Check-VeeamBackupForOffice365Jobx86.ps1` in `%ProgramFiles x86%\PRTG Network Monitor\Custom Sensors\EXEXML` on your PRTG server.
* From the `lookups` folder, copy `veeam-archiver-powershell-model-enums-vbojobstatus.ovl` into `%ProgramFiles x86%\PRTG Network Monitor\lookups\custom` and load it (PRTG > Setup > Administrative Tools > Load Lookups and File Lists > Go!).
* In PRTG, create a new sensor of type `EXE/Script Advanced` for your device
    * Name it, for example `Veeam O365 job status`
    * Choose the EXE/Script `Check-VeeamBackupForOffice365Jobx86.ps1`.
    * Specify parameters
        * At a minimum you must tell it which host to connect to, for example `-Target %host`
        * You can specify a job GUID, for example `-Target %host -JobGuid 'guid-goes-here'`.  If you don't specify one, it will just work with the first job that the `Get-VBOJob` script happens to return.
    * Choose whether to record the PowerShell errors or results with the Result Handling setting.
    * Choose to run the script with the parent device's Windows credentials, as the PRTG server machine (service?)account typically won't have access to your Veeam server.

# Notes
* PRTG runs scripts with Windows PowerShell (x86).  The Veeam module for PowerShell seems to require the x64 version, plain old Windows PowerShell.  So `Check-VeeamBackupForOffice365Jobx86.ps1` is a wrapper that runs `Check-VeeamBackupForOffice365Job.ps1` in an x64 instance.