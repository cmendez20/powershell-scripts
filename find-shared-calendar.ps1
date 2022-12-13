# Get all mailboxes:
$mailboxes = Get-Mailbox

# Use $mailboxes variable to get a list of all mailbox folder objects:
$folders = $mailboxes | Get-MailboxFolderStatistics

# Search through all $folders.Identity attributes (which are strings) for the folders in question
$folders.Identity | Select-String -Pattern "folderNameHere"