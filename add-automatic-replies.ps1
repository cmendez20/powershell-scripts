
Connect-ExchangeOnline -InlineCredential
try {
    Get-Mailbox knightms
    $InternMsg = "Hello,<br />
    <br />
    `nPlease note, this is an unmonitored mailbox.<br />
    <br />
    `nIf you test need IT assistance, please email support@knightoffice.com. For more urgent issues, please call us at (210) 340-8909 and one of our dedicated Service Desk Technicians will assist.<br />
    <br />
    `nThank you,<br />
    <br />
    `nKnight Office Solutions<br />
    `nIT Support<br />
    "
    Set-MailboxAutoReplyConfiguration -Identity knightms -AutoReplyState Enabled -InternalMessage $InternMsg -ExternalAudience None
}
catch {Write-Host 'No knightms inbox '}
finally {
    Disconnect-ExchangeOnline
}

