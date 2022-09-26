Connect-ExchangeOnline
$InternMsg = "Hello,
`Please note, this is an unmonitored mailbox.
`If you need IT assistance, please email support@knightoffice.com. For more urgent issues, please call us at (210) 340-8909 and one of our dedicated Service Desk Technicians will assist.
`Thank you,
`Knight Office Solutions
`IT Support
"

Set-MailboxAutoReplyConfiguration -Identity knightms -AutoReplyState Enabled -InternalMessage $InternMsg -ExternalAudience None
Disconnect-ExchangeOnline