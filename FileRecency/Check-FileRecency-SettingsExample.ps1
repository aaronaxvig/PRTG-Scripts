[System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("UseDeclaredVarsMoreThanAssignments", "SnmpInfo")]
$filesToCheck = @(
    @{
        NameForChannel      = "Server1 DB_dump"
        FileSearchString   = "\\backups\Server1\DB_dump_*"
        MinimumSize = 800MB
        MaximumAge  = New-TimeSpan -Hours 30
    }

    @{
        NameForChannel      = "Server2 DB_dump"
        FileSearchString   = "\\backups\Server2\DB_dump_*"
        MinimumSize = 10GB
        MaximumAge  = New-TimeSpan -Hours 30
    }
)