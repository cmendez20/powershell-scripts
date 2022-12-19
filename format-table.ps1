$userToOffboard = "hfields@s22f.onmicrosoft.com"
$displayName = Get-AzureADUser -ObjectID $userToOffboard 


write-host "Removing License from user." -ForegroundColor Green
$AssignedLicensesTable = Get-AzureADUser -ObjectId $userToOffboard | Get-AzureADUserLicenseDetail | Select-Object @{n="License"; e = { $_.SkuPartNumber }}, skuid 



$AssignedLicensesTable | Add-Member -MemberType NoteProperty  -Name 'User' -Value $displayName.DisplayName


# $AssignedLicensesTable | Get-Member



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

# $AssignedLicensesTable | Get-Member 
# $AssignedLicensesTable = $AssignedLicensesTable | Add-Member -MemberType NoteProperty "User" -Value $displayName 
# have to delete old csv sheet and start new one 
write-host "Export CSV to current directory.."
$AssignedLicensesTable | Export-CSV 'offboard-user-data-test.csv' -Append -Force 