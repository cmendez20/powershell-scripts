# works
# Set-DynamicDistributionGroup -Identity 'All Staff' -RecipientFilter {((RecipientType -eq 'UserMailbox') -and -not (UserAccountControl -eq "AccountDisabled, NormalAccount"))}

# works
# Set-DynamicDistributionGroup -Identity 'All Staff' -RecipientFilter {((RecipientType -eq 'UserMailbox') -and (UserAccountControl -ne '514'))}

# works
Set-DynamicDistributionGroup -Identity 'All Staff' -RecipientFilter {((RecipientType -eq 'UserMailbox') -and ((UserAccountControl -eq '512') -or (UserAccountControl -eq '544') -or (UserAccountControl -eq '66048')))}

# 514 = disabled account
# 512 = normal account
# 544 = Enabled, Password Not Required	
# 66048 = Enabled, Password Doesn’t Expire	

