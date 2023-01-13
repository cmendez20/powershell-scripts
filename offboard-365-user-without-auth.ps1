#########User info######
$userToOffboard = "wendyo@gastroclinicsa.com"
$displayName = Get-AzureADUser -ObjectID $userToOffboard 
# $CustomerDefaultDomainname = "gastroclinicsa.com"

write-host "Removing users from Azure AD Groups" -ForegroundColor Green
$MemberID = (Get-AzureADUser -ObjectId $userToOffboard).objectId
Get-AzureADUserMembership -ObjectId $MemberID -All $true | Where-Object { $_.ObjectType -eq "Group" -and $_.SecurityEnabled -eq $true -and $_.MailEnabled -eq $false } | ForEach-Object {
    write-host "    Removing using from $($_.displayname)" -ForegroundColor green
    Remove-AzureADGroupMember -ObjectId $_.ObjectID -MemberId $MemberID
}


write-host "Removing users from Unified Groups and Teams" -ForegroundColor Green
$OffboardingDN = (get-mailbox -Identity $userToOffboard -IncludeInactiveMailbox).DistinguishedName
Get-Recipient -Filter "Members -eq '$OffboardingDN'" -RecipientTypeDetails 'GroupMailbox' | foreach-object {
    write-host "    Removing using from $($_.name)" -ForegroundColor green
    Remove-UnifiedGroupLinks -Identity $_.ExternalDirectoryObjectId -Links $userToOffboard -LinkType Member -Confirm:$false }

write-host "Removing users from Distribution Groups" -ForegroundColor Green
Get-Recipient -Filter "Members -eq '$OffboardingDN'" | foreach-object {
    write-host "    Removing using from $($_.name)" -ForegroundColor green
Remove-DistributionGroupMember -Identity $_.ExternalDirectoryObjectId -Member $OffboardingDN -BypassSecurityGroupManagerCheck -Confirm:$false }

#Set Sign in Blocked
write-host "Blocking user's sign-in" -ForegroundColor Green
Set-AzureADUser -ObjectId $userToOffboard -AccountEnabled $false

write-host "Setting mailbox to Shared Mailbox" -ForegroundColor Green
Set-Mailbox $userToOffboard -Type Shared
write-host "Hiding user from GAL" -ForegroundColor Green
Set-Mailbox $userToOffboard -HiddenFromAddressListsEnabled $true

# remove inbox rules
# write-host "Removing inbox rules" -ForegroundColor Green
# get-inboxrule -Mailbox $Username | fl name,description
# get-inboxrule -Mailbox $Username | remove-o365-inboxrule

#Disconnect Existing Sessions
write-host "Signing user out of all 365 sessions" -ForegroundColor Green
Get-AzureADUser -SearchString $userToOffboard | Revoke-AzureADUserAllRefreshToken


write-host "Removing License from user." -ForegroundColor Green
$AssignedLicensesTable = Get-AzureADUser -ObjectId $userToOffboard | Get-AzureADUserLicenseDetail | Select-Object @{n = "License"; e = { $_.SkuPartNumber }}, skuid
if ($AssignedLicensesTable) {
$body = @{
        addLicenses    = @()
        removeLicenses = @($AssignedLicensesTable.skuid)
}
Set-AzureADUserLicense -ObjectId $userToOffboard -AssignedLicenses $body
}

write-host "Removed licenses:"
$AssignedLicensesTable

$AssignedLicensesTable | Add-Member -MemberType NoteProperty  -Name 'User' -Value $displayName.DisplayName
$AssignedLicensesTable | Export-CSV 'offboard-user-data.csv' -Append -Force 