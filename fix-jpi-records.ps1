$DownloadsPath = "C:\Users\knightms\Downloads"
$RecordsPath = "\\192.168.1.124\datto-nas\SystemX\Database\BradfordRecords"

# sign out all users except knightms
Write-Host "Signing out all users except knightms..." -ForegroundColor Yellow
((Get-WmiObject -Class Win32_Process).getowner().user | Select-Object  -Unique) |ForEach-Object {query session $_ | where-object {($_ -notmatch 'console') -and ($_ -match 'disc') -and ($_ -notmatch 'services')}| logoff}
query session | Where-Object{ ($_ -notmatch '^ SESSIONNAME') -and ($_ -notmatch '<username>') }
query session $_ | Where-Object { ($_ -match 'console') -and ($_ -match 'disc') } | logoff
# quser | Select-String “Disc” | ForEach-Object {logoff ($_.tostring() -split ‘ +’)[2]}
# (quser) -notlike ">$env:USERNAME *" | Select-Object -Skip 1 | ForEach-Object { logoff ($_ -split ' +')[-5] }
Write-Host "DONE" -ForegroundColor Yellow

# In BradfordRecords, delete all .ldb files
do {
    $Failed = $false
    try {
        Write-Host "Deleting all .ldb files in $RecordsPath..." -ForegroundColor Yellow
        Get-ChildItem $RecordsPath * -Include *.ldb -Recurse | Remove-Item
        Write-Host 'Done. .ldb files have been deleted succesfully' -ForegroundColor Yellow
    }
    catch {
        Write-Host 'Unable to delete .ldb files, reboot Datto device...' -ForegroundColor Yellow
        # Kills all processes of MSACCESS.exe
        Stop-Process -Name MSACCESS
        # Start-Process "https://auth.datto.com/login"
        Read-Host -Prompt "After reboot, press any key to continue"
        $Failed = $true
    }
} while ($Failed)

# Copy Bradford Records_be.mdb & JPI Records NEW CURRENT.md from Bradford Records to the Local Downloads Folder
Write-Host "Copying Bradford Records_be.mdb & JPI Records NEW CURRENT.md to local Downloads folder" -ForegroundColor Yellow
Copy-Item -Path $RecordsPath\Bradford Records_be.mdb, $RecordsPath\JPI Records NEW CURRENT.md -Destination $DownloadsPath -Force
Write-Host "DONE" -ForegroundColor Yellow

# Open Bradford Records_BE.mdb
# Click ok on any prompts that come up to fully open the database

# Compact and Repair Bradford Records_be.mdb
# It is not recommended to let an MDB file exceed 1.7GB in size.
# msaccess <path to database file>\<database file name> /compact
Write-Host "Repairing Bradford Records_be.mdb..." -ForegroundColor Yellow

Set-Variable objAccess = CreateObject(“Access.Application”)

errReturn = objAccess.CompactRepair _
    ("$DownloadsPath\Bradford Records_BE.mdb", “$DownloadsPath\Bradford Records_BE_Repaired.mdb”)

Wscript.Echo “Compact/repair succeeded: ” & errReturn

# Rename repaired file to og name
Move-Item -Path $DownloadsPath\Bradford Records_BE_Repaired.mdb -Destination $DownloadsPath\Bradford Records_BE.mdb -Force

# In R:\BradfordRecords, delete all .ldb files
Write-Host "Deleting .ldb files in $RecordsPath AGAIN" -ForegroundColor Yellow
Get-ChildItem $RecordsPath * -Include *.ldb -Recurse | Remove-Item
Write-Host "DONE" -ForegroundColor Yellow

# Force copy and paste Repaired Bradford Records_be.mdb & JPI Records NEW CURRENT.mdb from local downloads into R:\BradfordRecords.
# Replace the files in the destination
Write-Host "Copying local files to $RecordsPath..." -ForegroundColor Yellow
Copy-Item -Path $DownloadsPath\Bradford Records_be.mdb, $DownloadsPath\JPI Records NEW CURRENT.md -Destination $RecordsPath -Force
Write-Host "DONE" -ForegroundColor Yellow

# Test Functionality
Write-Host "You may now begin testing the files. Opening General Work Database..." -ForegroundColor Yellow
Write-Host "-----------------------------------------------------------------"
Write-Host '1) Click the yellow ribbon to enable content and click the down arrow on the "WorkID" field.' -ForegroundColor Yellow
Write-Host '2) If names appear General Works is operational: Click the "STOP" button to close General Works'
# Start-Process C:\Users\chrsm\Desktop\Stacher.lnk -Wait
Start-Process "\\192.168.1.124\datto-nas\SystemX\Database\GeneralWork CURRENT.mdb" -Wait
Write-Host "-----------------------------------------------------------------"
Write-Host "Now opening JPI Records. If you get any prompts click ok or yes to proceed..." -ForegroundColor Yellow
Write-Host '1) Click the yellow ribbon to enable content. From here click on the "Jobs/Work Orders Control Center" button' -ForegroundColor Yellow
Write-Host '2) Next click in the "Job Address" field'
Write-Host '3) Type two random numbers and see if an address populates. If it does Records is fully functional.'
Write-Host '4) Click the "Done" button at the top to go back to the main form screen'
Write-Host '5) Finally click "Close Program" to close JPI records'
Start-Process "R:\BradfordRecords\JPI Records NEW CURRENT.mdb" -Wait

Write-Host "Now call Megan or Nick to reboot their computers and test access"
Write-Host "If they get any prompts tell them to continue"
Write-Host "If it works databases should be repaired and ticket can be closed"


