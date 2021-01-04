# To use

* Copy all the PowerShell files into `%ProgramFiles x86%\PRTG Network Monitor\Custom Sensors\EXEXML` on your PRTG server.
* Copy all the lookup files in `lookups` into `%ProgramFiles x86%\PRTG Network Monitor\lookups\custom` and load them (PRTG > Setup > Administrative Tools > Load Lookups and File Lists > Go!).
* Rename `SnmpCredentialsExample.ps1` to `SnmpCredentials.ps1` and then edit its contents to provide SNMPv3 credential info for logging in to your devices.
* Open Windows Powershell (x86) on your server as administrator and run two commands to install required Powershell modules:
    * Install-Module PrtgXml
    * Install-Module SNMPv3
* In PRTG, create a new sensor of type `EXE/Script Advanced` for your device
    * Name it, for example `Bank status`
    * Choose an EXE/Script, for example `Check-ApcRpdu2BankStatus.ps1`
    * Specify parameters, for example `-Target %host` or `-Target %host -SnmpCredentialsFile Creds.ps1`
    * Choose whether to record the PowerShell errors or results with the Result Handling setting.

# Troubleshooting

To log issues with the script, make sure the Result Handling setting on the sensor is set to `Store result` (stores in cases of goor results or errors) or `Store result in case of error` (stores only for an error).  Those logs can be found in `%ProgramData%\Paessler\PRTG Network Monitor\Logs\sensors`.

Another useful technique is to manually run the script.  In Windows PowerShell (x86):
````
cd C:\Program Files (x86)\PRTG Network Monitor\Custom Sensors\EXEXML
.\Check-ApcRpdu2BankStatus.ps1 -Target 10.0.0.123
````