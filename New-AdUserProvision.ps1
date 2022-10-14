param (
	[Parameter(Mandatory, ValueFromPipelineByPropertyname)]
	[ValidateNotNullOrEmpty()]
	[string]$FirstName,
	
	[Parameter(Mandatory, ValueFromPipelineByPropertyname)]
	[ValidateNotNullOrEmpty()]
	[string]$LastName,
	
	[Parameter(Mandatory, ValueFromPipelineByPropertyname)]
	[ValidateNotNull()]
  [AllowEmptyString()]
	[string]$MiddleInitial,
	
	# [Parameter(Mandatory, ValueFromPipelineByPropertyname)]
	# [ValidateNotNullOrEmpty()]
	# [string]$Department,
	
	[Parameter(Mandatory, ValueFromPipelineByPropertyname)]
	[ValidateNotNull()]
  [AllowEmptyString()]
	[string]$Title,
	
	[Parameter(ValueFromPipelineByPropertyname)]
	[ValidateNotNullOrEmpty()]
	[string]$Location = 'OU=_USERS',
	
	[Parameter()]
	[ValidateNotNullOrEmpty()]
	[string]$DefaultGroup = '1 EMPLOYEES',
	
	[Parameter()]
	[ValidateNotNullOrEmpty()]
	[string]$DefaultPassword = "$($FirstName.SubString(0, 1).ToUpper())$($LastName.SubString(0, 1).ToUpper())@welcome$(get-date -f yyyy)"
	
	# [Parameter()]
	# [ValidateScript({ Test-Path -Path $_ })]
	# [string]$BaseHomeFolderPath = '\\dc\Users'
)

## Find the distinguished name of the domain the current computer is a part of.
$DomainDn = (Get-AdDomain).DistinguishedName
## Define the 'standard' username (first initial and last name)
$Username = "$($FirstName.SubString(0, 1))$LastName"

# Converts first name and last name to Title Case
$FirstName = $FirstName.substring(0,1).toupper()+$FirstName.substring(1).tolower()    
$LastName = $LastName.substring(0,1).toupper()+$LastName.substring(1).tolower()    

#region Check if an existing user already has the first initial/last name username taken
Write-Verbose -Message "Checking if [$($Username)] is available"
if (Get-ADUser -Filter "Name -eq '$Username'")
{
	Write-Warning -Message "The username [$($Username)] is not available. Checking alternate..."
	## If so, check to see if the first initial/middle initial/last name is taken.
	$Username = "$($FirstName.SubString(0, 1))$MiddleInitial$LastName"
	if (Get-ADUser -Filter "Name -eq '$Username'")
	{
		throw "No acceptable username schema could be created"
	}
	else
	{
		Write-Verbose -Message "The alternate username [$($Username)] is available."
	}
}
else
{
	Write-Verbose -Message "The username [$($Username)] is available"
}
#endregion

#gets domain name
$Domain = Get-ADForest

#region Ensure the OU the user's going into exists
$ouDN = "$Location,$DomainDn"
if (-not (Get-ADOrganizationalUnit -Filter "DistinguishedName -eq '$ouDN'"))
{
	throw "The user OU [$($ouDN)] does not exist. Can't add a user there"
}
#endregion

#region Ensure the group the user's going into exists
if (-not (Get-ADGroup -Filter "Name -eq '$DefaultGroup'"))
{
	throw "The group [$($DefaultGroup)] does not exist. Can't add the user into this group."
}
# if (-not (Get-ADGroup -Filter "Name -eq '$Department'"))
# {
# 	throw "The group [$($Department)] does not exist. Can't add the user to this group."
# }
#endregion

#region Ensure the home folder to create doesn't already exist
# $homeFolderPath = "$BaseHomeFolderPath\$UserName"
# if (Test-Path -Path $homeFolderPath)
# {
# 	throw "The home folder path [$homeFolderPath] already exists."
# }
#endregion

#region Create the new user
$NewUserParams = @{
	'UserPrincipalName' = "$Username@$Domain"
	'Name' = $FirstName + ' ' + $LastName
	'GivenName' = $FirstName
	'Surname' = $LastName
	'Title' = $Title
	# 'Department' = $Department
	'SamAccountName' = $Username
  'DisplayName' = $FirstName + ' ' + $LastName
	'AccountPassword' = (ConvertTo-SecureString $DefaultPassword -AsPlainText -Force)
	'Enabled' = $true
	'Initials' = $MiddleInitial
	'Path' = "$Location,$DomainDn"
	'ChangePasswordAtLogon' = $true
}
Write-Verbose -Message "Creating the new user account [$($Username)] in OU [$($ouDN)]"
New-AdUser @NewUserParams
#endregion

#region Add user to groups
Write-Verbose -Message "Adding the user account [$($Username)] to the group [$($DefaultGroup)]"
Add-ADGroupMember -Members $Username -Identity $DefaultGroup
# Write-Verbose -Message "Adding the user account [$($Username)] to the group [$($Department)]"
# Add-ADGroupMember -Members $Username -Identity $Department
#endregion

#region Create the home folder
# Write-Verbose -message "Creating the home folder [$homeFolderPath]..."
# $null = mkdir $homeFolderPath
#endregion

Write-Verbose -Message "[$($Username)] has been created]"
