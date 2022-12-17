$ADUsers = Import-csv C:\newusers.csv #import a path to CSV file with new users

foreach ($User in $ADUsers) {
        $Username = $User.username
        $Password = $User.password
        $Firstname = $User.firstname
        $Lastname = $User.lastname
        $Department = $User.department
        $OU = $User.ou

    #check if user already exist
    if (Get-ADUser -F {SamAccountName -eq $Username}) { 
        #if user exists write warning
        Write-Warning "$Username already exists"
        }
    else {
        #creating new user
        #account will be created in OU you entered in $OU variable, 
        New-ADUser `
            -SamAccountName $Username `
            -UserPrincipalName "$Username@domain.com" ` #dont forget to change domain 
            -Name "$Firstname $Lastname" `
            -GivenName $Firstname `
            -Surname $Lastname `
            -Enabled $True `
            -ChangePasswordAtLogon $True `
            -DisplayName "$Lastname, $Firstname" `
            -Department $Department `
            -Path $OU `
            -AccountPassword (convertto-securestring $Password -AsPlainText -Force)
    }
}