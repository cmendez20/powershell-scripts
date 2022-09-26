Write-Host "Repairing Bradford Records_be.mdb..." -ForegroundColor Yellow

Set-Variable objAccess = CreateObject(“Access.Application”)

errReturn = objAccess.CompactRepair _
    ("$DownloadsPath\Bradford Records_BE.mdb", “$DownloadsPath\Bradford Records_BE_Repaired.mdb”)

Wscript.Echo “Compact/repair succeeded: ” & errReturn