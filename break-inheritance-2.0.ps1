# gets names of folders in the current directory
$folderNames = Get-ChildItem -Directory | Select-Object -ExpandProperty Name

# loops through all folders
For ($i=0; $i -lt $folderNames.length; $i++) {
  $folderPath = "\\ts-main\Scans\$($folderNames[$i])"

  try {
    # adds the scans user to the security tab with modify, read, write, execute permissions 
    $identity = "scans"
    $rights = 'Modify' #Other options: [enum]::GetValues('System.Security.AccessControl.FileSystemRights')
    $inheritance = 'ContainerInherit, ObjectInherit' #Other options: [enum]::GetValues('System.Security.AccessControl.Inheritance')
    $propagation = 'None' #Other options: [enum]::GetValues('System.Security.AccessControl.PropagationFlags')
    $type = 'Allow' #Other options: [enum]::GetValues('System.Securit y.AccessControl.AccessControlType')
    $ACE = New-Object System.Security.AccessControl.FileSystemAccessRule($identity,$rights,$inheritance,$propagation, $type)
  
    # gets current access control list and sets the new permissions
    $Acl = Get-Acl -Path "$folderPath"
    $Acl.AddAccessRule($ACE)
  
    Write-Host "Adding $($folderNames[$i]) scan user permissions" -ForegroundColor cyan -BackgroundColor black
    Set-Acl -Path "$folderPath" -AclObject $Acl
  }
  catch {
    Write-Host "$($folderNames[$i]) unable to add scans user" -ForegroundColor red -BackgroundColor black
    Write-Output "$($folderNames[$i])" | Out-File ./failed.txt
  }

  Write-Host "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
}

