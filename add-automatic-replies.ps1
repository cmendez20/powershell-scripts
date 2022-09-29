$emails = Import-Excel .\customers.xlsx

$emails.forEach(
    {  
      $credential = New-Object System.Management.Automation.PsCredential($_,$password)

      try {

        # Connect-ExchangeOnline -InlineCredential
        # Connect-ExchangeOnline -UserPrincipalName $_
        Connect-ExchangeOnline -Credential $credential
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
        Write-Host "Knightms mailbox was found and automatic reply has been set."
      }
      
      catch {
        Write-Output 'FAILED: $($.Exception.Message)'
        '`n$($_)' | Out-File C:\Users\Chris\errors.txt -Append
    }
      
      finally {
        Disconnect-ExchangeOnline
      }
  }
)


