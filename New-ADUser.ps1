New-ADUser `
    -Name "Kevin Sapp" `
    -GivenName "Kevin" `
    -Surname "Sapp" `
    -SamAccountName "kesapp-test" `
    -AccountPassword (Read-Host -AsSecureString "Input User Password") `
    -ChangePasswordAtLogon $True `
    -Description "Test Account Creation" `
    -DisplayName "Kevin Sapp (Test)" `
    -Enabled $True