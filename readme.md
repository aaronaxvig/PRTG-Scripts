These are PowerShell scripts that PRTG can run to pull in data for various systems.

Many of them use SNMP to get the data, even though PRTG has built-in SNMP capabilities.  This allows for more customization, such as:
* Converting units - For example the APC UPS OID `1.3.6.1.4.1.318.1.1.1.4.3.4.0` sends 3.4 amps as `34` (deciamps) since SNMP doesn't support float values.  I don't want to look at deciamps in PRTG, and PRTG has no capability to divide this value by 10, but this is quite easy to do in PowerShell.
* Parsing weird dates/times - Consider OID `1.3.6.1.4.1.318.1.1.1.2.1.2.0` which provides the time an APC UPS has been running on battery in the format `mm:ss`.  I can parse that and specify it in integer seconds which is a well-supported measurement in PRTG.
* Making dates more useful - Again we can look at APC, OID `1.3.6.1.4.1.318.1.1.1.2.1.3.0`.  It provides the date that batteries were replaced.  Since we are interested more in the age than the actual date, I can calculate the age and send that to PRTG.  An warning can be set for age > 3 years, but not for a date being 3 years in the past.  Plus if the date was stored in PRTG, I would just be calculating the age in my head everytime I look at it.

Details of how to use each type of script are in each folders' `readme.md` file.