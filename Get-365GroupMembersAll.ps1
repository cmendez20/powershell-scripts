$Groups = Get-UnifiedGroup -ResultSize Unlimited
$GroupData = foreach ($group in $Groups) {
    $GroupOwners = Get-UnifiedGroupLinks -Identity $group.Name -LinkType Owners -ResultSize Unlimited
    $GroupMembers = Get-UnifiedGroupLinks -Identity $group.Name -LinkType Members -ResultSize Unlimited
    
    # Group owners
    foreach ($owner in $GroupOwners) {
        [PSCustomObject][ordered]@{
            Group         = $group.DisplayName
            Member        = $owner.Name
            Type          = "Owner"
            EmailAddress  = $owner.PrimarySMTPAddress
            RecipientType = $owner.RecipientType
        }
    }
    
    # Group members
    foreach ($member in $GroupMembers) {
        [PSCustomObject][ordered]@{
            Group         = $group.DisplayName
            Member        = $member.Name
            Type          = "Member"
            EmailAddress  = $member.PrimarySMTPAddress
            RecipientType = $member.RecipientType
        }
    }

}
$GroupData | Export-CSV ".\Office365DistroMembers.csv" -NoTypeInformation -Encoding UTF8