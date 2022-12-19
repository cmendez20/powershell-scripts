$userToOffboard = "afergy@s22f.onmicrosoft.com"
$displayName = Get-AzureADUser -ObjectID $userToOffboard 


write-host "Removing License from user." -ForegroundColor Green
$AssignedLicensesTable = Get-AzureADUser -ObjectId $userToOffboard | Get-AzureADUserLicenseDetail | Select-Object @{n="License"; e = { $_.SkuPartNumber }}, skuid 

# $AssignedLicensesTable | Get-Member

$AssignedLicensesTable | Add-Member -MemberType NoteProperty  -Name 'User' -Value $displayName.DisplayName

$AssignedLicensesTable | Get-Member



# $AssignedLicensesTable = Get-AzureADUser -ObjectId $userToOffboard | Get-AzureADUserLicenseDetail | Add-Member -NotePropertyName User -NotePropertyValue $displayName | Select-Object @{n = "License"; e = { $_.SkuPartNumber }; c = 'test'}, skuid, 


# $AssignedLicensesTable = Get-AzureADUser -ObjectId $userToOffboard | Get-AzureADUserLicenseDetail


# if ($AssignedLicensesTable) {
# $body = @{
#         addLicenses    = @()
#         removeLicenses = @($AssignedLicensesTable.skuid)
# }
# Set-AzureADUserLicense -ObjectId $userToOffboard -AssignedLicenses $body
# }

write-host "Removed licenses:"
# $AssignedLicensesTable.GetType()
$AssignedLicensesTable 


# $AssignedLicensesTable = $AssignedLicensesTable | Add-Member -MemberType NoteProperty "User" -Value $displayName 
# $AssignedLicensesTable | Export-CSV 'offboard-user-data.csv' -Append -Force 