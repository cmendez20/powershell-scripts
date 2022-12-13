## Original Filter
# Set-DynamicDistributionGroup -Identity 'All Staff' -RecipientFilter "((((((RecipientType -eq 'UserMailbox') -and (-not(RecipientTypeDetailsValue -eq 'SharedMailbox'))))
# -and (-not(RecipientTypeDetailsValue -eq 'RoomMailbox')))) -and (-not(Name -like 'SystemMailbox{*'))
# -and -not(UserAccountControl -eq 'AccountDisabled, NormalAccount')
# -and (-not(Name -like 'CAS_{*')) -and (-not(RecipientTypeDetailsValue -eq 'MailboxPlan')) -and
# (-not(RecipientTypeDetailsValue -eq 'DiscoveryMailbox')) -and (-not(RecipientTypeDetailsValue -eq
# 'PublicFolderMailbox')) -and (-not(RecipientTypeDetailsValue -eq 'ArbitrationMailbox')) -and
# (-not(RecipientTypeDetailsValue -eq 'AuditLogMailbox')) -and (-not(RecipientTypeDetailsValue -eq
# 'AuxAuditLogMailbox')) -and (-not(RecipientTypeDetailsValue -eq 'SupervisoryReviewPolicyMailbox')))"



# Set-DynamicDistributionGroup -Identity "All Staff" -RecipientFilter {((RecipientType -eq 'UserMailbox') -and -not (UserAccountControl -eq 'AccountDisabled, NormalAccount') -and (-not(RecipientTypeDetailsValue -eq 'RoomMailbox')))}

# Set-DynamicDistributionGroup -identity "All Staff" -RecipientFilter {((RecipientType -eq 'UserMailbox') -and -not (RecipientTypeDetailsValue -eq 'RoomMailbox') `
# -and -not (RecipientTypeDetailsValue -eq 'SharedMailbox') -and -not (UserAccountControl -eq "AccountDisabled, NormalAccount"))} 

# -and -not (RecipientTypeDetailsValue -eq 'RoomMailbox') 
# -and -not(UserAccountControl -eq 'AccountDisabled, NormalAccount')

# Set-DynamicDistributionGroup -identity "All Staff" -RecipientFilter {((RecipientType -eq 'UserMailbox') -and (UserAccountControl -eq '66048') -and (UserAccountControl -eq '512') -and (UserAccountControl -eq '544') -and -not (RecipientTypeDetailsValue -eq 'RoomMailbox'))}


# New-DynamicDistributionGroup "AllEmployees" -RecipientFilter {((RecipientType -eq 'UserMailbox') -and -not (UserAccountControl -eq "AccountDisabled, NormalAccount"))}



# WORKING but have to disable users manually
Set-DynamicDistributionGroup -identity "All Staff" -RecipientFilter {((RecipientType -eq 'UserMailbox') -and -not (RecipientTypeDetailsValue -eq 'RoomMailbox') `
-and -not (RecipientTypeDetailsValue -eq 'SharedMailbox') `
-and (Name -ne 'Tonya Lott') `
-and (Alias -ne 'kluse'))}
# -and (Alias -ne 'AHunt') `

# Get members of a recipient filter 
# $FTE = Get-DynamicDistributionGroup "HR"
#  Get-Recipient -RecipientPreviewFilter $FTE.RecipientFilter