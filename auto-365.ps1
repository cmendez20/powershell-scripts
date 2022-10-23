Connect-ExchangeOnline -InlineCredential
Clear-Host

function DisplayMenu {
  # Clear-Host
  Write-Host "
  +===============================================+
  |  (っ▀¯▀)つ It's Hackin Time                   | 
  +===============================================+
  |                                               |
  |    1) Add user to shared mailbox              |
  |    2) Block sender                            |
  |    3) Add user to personal calendar           |
  |    4) EXIT                                    |
  +===============================================+
  
  "
  
  $MENU = Read-Host "OPTION"
  Switch ($MENU)
  {
    1 {
      #OPTION1 - Add user to shared mailbox
      $mailbox = Read-Host "What is the email of the shared mailbox?"
      $personToAdd = Read-Host "What is the email of the person you want to add to the shared mailbox?"
      Write-Host "Adding $personToAdd to $mailbox shared mailboxes with Read & Manage Permissions"
      Add-MailboxPermission -Identity $mailbox -User $personToAdd -AccessRights FullAccess -InheritanceType All
      # Start-Sleep -Seconds 2
      # DisplayMenu
    }

    2 {
      #OPTION2 - Block Sender
      $emailToBlock = Read-Host "What is the email to block?"
      Write-Host "Block $emailToBlock across entire organization"

      Set-HostedContentFilterPolicy default -BlockedSenderDomains @{add="$emailToBlock"}
      # Start-Sleep -Seconds 2
      # DisplayMenu
    }

    3 {
      #OPTION2 - Add user to another user's calendar
      $calendarToShare = Read-Host "What is the email of the calendar you want to share?"
      $userToAdd = Read-Host "What is the email of the person you want to give permission?"
      Add-MailboxFolderPermission -Identity "$($calendarToShare):\calendar" -user $userToAdd -AccessRights Reviewer -SendNotificationToUser $True
      Start-Sleep -Seconds 2
      DisplayMenu
    }

    4 {
      #OPTION4 - EXIT
      Write-Host "Good day Knight (づ｡◕‿‿◕｡)づ"
      Disconnect-ExchangeOnline -Confirm:$false
      Break
    }
    
    default {
      #DEFAULT OPTION
      Write-Host "IMPOSSIBLE (╯°□°）╯︵ ┻━┻"
      Start-Sleep -Seconds 2
      DisplayMenu
    }
  }
}

DisplayMenu



# $shareMailbox = New-Object System.Management.Automation.Host.ChoiceDescription '&Add to shared mailbox', 'Add to shared mailbox'
# $blockSender = New-Object System.Management.Automation.Host.ChoiceDescription '&Block sender', 'Block sender'
# $addToCalendar = New-Object System.Management.Automation.Host.ChoiceDescription '&Add to a calendar', 'Add to Calendar'

# $options = [System.Management.Automation.Host.ChoiceDescription[]]($shareMailbox, $blockSender, $addToCalendar)

# $title = '================ Welcome Knight ================'
# $message = 'What would you like to do today?'
# $result = $host.ui.PromptForChoice($title, $message, $options, 0)

# switch ($result)
# {
#     0 { 
#       $mailbox = Read-Host "What is the mailbox you want to share?"
#       $personToAdd = Read-Host "What is the email of the person you want to add to mailbox?"
#       Write-Host "Adding $personToAdd to $mailbox with Read & Manage Permissions"
#      }
#     1 { 
#       $emailToBlock = Read-Host "What is the email to block?"
#       Write-Host "Block $emailToBlock across entire organization"

#       Set-HostedContentFilterPolicy default -BlockedSenderDomains @{add="$emailToBlock"}
#     }
#     2 { 
#       $calendarToShare = Read-Host "What is the email of the calendar you want to share?"
#       $userToAdd = Read-Host "What is the email of the person you want to give permission?"
#       Add-MailboxFolderPermission -Identity "$calendarToShare":\calendar -user $userToAdd -AccessRights Reviewer -SendNotificationToUser $True
#      }
#     Default {
#       "No matches"
#     }
# }

# Write-Host "test"
# Disconnect-ExchangeOnline -Confirm:$false