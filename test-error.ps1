
Write-Host "You may now begin testing the files" -ForegroundColor Yellow
Write-Host "-----------------------------------------------------------------"
Write-Host 'Click the yellow ribbon to enable content and click the down arrow on the "WorkID" field.' -ForegroundColor Yellow
Write-Host 'If names appear General Works is operational. Click the "STOP" button to close General Works' -ForegroundColor Yellow
Start-Process C:\Users\chrsm\Desktop\Stacher.lnk -Wait

Write-Host 'done with scripst'



# do {
#   $Failed = $false
#   try {
#     Start-Process C:\Users\chrsm\test8.txt
#     Write-Host 'Done. Files have been deleted' -ForegroundColor Yellow
#     Write-Progress -Activity "Searching Events" -Status "Progress:" -PercentComplete 50
#   }
#   catch {
#     Write-Progress -Activity "Searching Events" -Status "Progress:" -PercentComplete 0
#     Write-Host 'error opening app' -ForegroundColor Yellow
#     Start-Process "https://auth.datto.com/login"
#     Read-Host -Prompt "After reboot, press any key to continue"
#     $Failed = $true
#   }
# } while ($Failed)

# Write-Progress -Activity "Done" -Status "Progress:" -PercentComplete 75

# Write-Host 'done with scripst'