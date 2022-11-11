Get-Mailbox -RecipientTypeDetails UserMailbox | Where-Object {$_.SkuAssigned -eq $true} | Get-MailboxStatistics | Where-Object {$_.LastLogonTime -lt (Get-Date).AddDays(-90)} | Select DisplayName,LastLogonTime | ft