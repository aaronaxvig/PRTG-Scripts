# To use

* Copy all the PowerShell files into `%ProgramFiles x86%\PRTG Network Monitor\Custom Sensors\EXEXML` on your PRTG server.
* Copy all the lookup files in `lookups` into `%ProgramFiles x86%\PRTG Network Monitor\lookups\custom` and load them (PRTG > Setup > Administrative Tools > Load Lookups and File Lists > Go!).
* Rename `SnmpV2CredentialsExample.ps1` to `SnmpV2Credentials.ps1` and then edit its contents to provide SNMPv2 credential info for logging in to your devices.
* Open Windows Powershell (x86) on your server as administrator and run commands to install required Powershell modules:
    * `Install-Module PrtgXml`
    * `Install-Module PoshSNMP`
* In PRTG, create a new sensor of type `EXE/Script Advanced` for your device
    * Name it, for example `Bank status`
    * Choose an EXE/Script, for example `Check-ZebraOdometer.ps1`
    * Specify parameters
        * At a minimum you must tell it which host to connect to, for example `-Target %host`
        * If you named your credentials file something other than the default `SnmpV2Credentials.ps1` then you can also specify that file, for example `-Target %host -SnmpV2CredentialsFile Creds.ps1`.  This would be useful if you needed to specify different credentials for certain devices.
    * Choose whether to record the PowerShell errors or results with the Result Handling setting.

# Troubleshooting

To log issues with the script, make sure the Result Handling setting on the sensor is set to `Store result` (stores in cases of goor results or errors) or `Store result in case of error` (stores only for an error).  Those logs can be found in `%ProgramData%\Paessler\PRTG Network Monitor\Logs\sensors`.  Only the latest result seems to be stored so it should not take up much space to always save the result.

Another useful technique is to manually run the script.  In Windows PowerShell (x86):
````
cd "%ProgramFiles x86%\PRTG Network Monitor\Custom Sensors\EXEXML"
.\Check-ApcRpdu2BankStatus.ps1 -Target host.example.com
````