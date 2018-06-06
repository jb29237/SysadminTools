<#
.Synopsis
   Resets an AD user account password
.DESCRIPTION
   Takes multi-string input for usernames. Resets users passwords by converting supplied password to "Secure-String"
.EXAMPLE
   Reset-ORGADUserPassword -Usernames "Johnny Test" -Password 'yourpassword'
.EXAMPLE
   Get-Content Usernames.txt | Reset-ORGADUserPassword -Password 'yourpassword'
#>
function Reset-ORGADUserPassword
{
    [CmdletBinding()]
    Param
    (
        # Supply usernames
        [Parameter(Mandatory = $true,
            ValueFromPipeline = $true,
            Position = 0)]
        [string[]]$Usernames,
        # Prompt for secure password
        [Parameter(Mandatory = $false,
            ValueFromPipeline = $true,
            Position = 1)]
        $Password = (Get-Credential).password 

        
    )

    Begin
    {
        $Secret = $Password 
        
        


    }
    
    Process
    {

        foreach($User in $Usernames)
        {
            $User = Get-ADObject -Filter {Name -like $User}
            
            if ($User) 
            {
                # Set new password
                Set-ADAccountPassword -Identity $User -NewPassword $Secret -Reset
                Set-ADUser -Identity $User -ChangePasswordAtLogon $True
                Write-Verbose "$($User.name) password has be changed"
            } 
            else 
            {
                # User not found--print an error
                Write-Verbose "$Usernames was not found in AD!"
            }

        }
        

    }
    
}