
$folderNames = Get-ChildItem -Directory | Select-Object -ExpandProperty Name

# loops through all folders
For ($i=0; $i -lt $folderNames.length; $i++) {
  $folderPath = "\\dc\data\dataTwo\$($folderNames[$i])"
  Write-Host "Removing inheritance for $($folderNames[$i])" -ForegroundColor cyan -BackgroundColor black

  # get current ACL for folder
  $Acl = Get-Acl -Path $folderPath

  # disables inheritance
  $Acl.SetAccessRuleProtection($true,$true)

  # filter for specific ACE you want to remove
  $AceToRemove = $Acl.Access | Where-Object {($_.IdentityReference -eq 'MYDOMAIN\Domain Users')}
  # $AceToRemove = New-Object System.Security.AccessControl.FileSystemAccessRule("MYDOMAIN\Domain Users", "FullControl", "Allow")

  # # removes ACE
  $Acl.RemoveAccessRule($AceToRemove)

  # make changes stick
  Set-Acl -Path $folderPath -AclObject $Acl

  # adds domain user
  # Create the ACE for domain user
  $identity = "$($folderNames[$i])"
  $rights = 'Modify' #Other options: [enum]::GetValues('System.Security.AccessControl.FileSystemRights')
  $inheritance = 'ContainerInherit, ObjectInherit' #Other options: [enum]::GetValues('System.Security.AccessControl.Inheritance')
  $propagation = 'None' #Other options: [enum]::GetValues('System.Security.AccessControl.PropagationFlags')
  $type = 'Allow' #Other options: [enum]::GetValues('System.Securit y.AccessControl.AccessControlType')
  $ACE = New-Object System.Security.AccessControl.FileSystemAccessRule($identity,$rights,$inheritance,$propagation, $type)

  $Acl = Get-Acl -Path "$folderPath"
  $Acl.AddAccessRule($ACE)

  Set-Acl -Path "$folderPath" -AclObject $Acl

  icacls.exe $folderPath /remove Everyone /T /C
}



For ($i=0; $i -lt $folderNames.length; $i++) {
  $folderPath = "\\dc\data\dataTwo\$($folderNames[$i])"
  icacls.exe $folderPath /remove "Domain Users" /T /C
}
