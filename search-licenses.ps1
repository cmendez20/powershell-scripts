# Get-Mailbox -RecipientTypeDetails UserMailbox | Where-Object {$_.SkuAssigned -eq $true} | Get-MailboxStatistics | Where-Object {$_.LastLogonTime -lt (Get-Date).AddDays(-90)} | Select DisplayName,LastLogonTime | ft

	
Connect-AzureAD
Get-AzureADUser -All $True | Where-Object { $_.AccountEnabled -eq $false} |
Select-Object UserPrincipalName, DisplayName |
Export-CSV "C:\365-reports\DisabledO365Users.csv" -NoTypeInformation -Encoding UTF8