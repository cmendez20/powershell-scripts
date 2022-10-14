Get-MailboxFolderStatistics -Identity "cwatson" | ForEach-Object {
If ($_.FolderPath -match "/Calendar/Rey SV/AO"){
    $FolderIdentity = ($_.Identity).Replace('\Calendar\', ':\Calendar\')
    Get-MailboxCalendarFolder -Identity $FolderIdentity | Select CalendarSharingOwnerSmtpAddress, SharingOwnerRemoteFolderId
}
}