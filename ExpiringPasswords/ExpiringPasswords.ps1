<#
.Synopsis
    Get information on AD users expiring passwords
.DESCRIPTION
    This will get information related to AD users password expiring properties and output them
    as PScustomObjects
.EXAMPLE
    Get-ExpiringPasswords -Usernames "Johnny Test"
.EXAMPLE
    Get-Content C:\users.txt | Get-ExpiringPasswords
.Example
    Get-ADUser -Filter {(Name -like "*") -and (Enabled -eq "True") -and (Passwordneverexpires -eq "False")} -Properties "*" | Select-Object -expandProperty Name | Get-ORGExpiringPasswords
#>
function Get-ORGExpiringPasswords
{
    [CmdletBinding()]
    Param
    (
        # Username(s) input
        [Parameter(Mandatory=$true,
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        [string[]]$Usernames,

        # Days less than or equal to password expiring
        [Parameter(Mandatory=$false,
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=1)]
        [int]$Days
    )

    Begin
    {
        $ADProperties = @(
        'Name',    
        'PasswordLastSet',
        'PasswordNeverExpires',
        'Mail',
        'msDS-UserPasswordExpiryTimeComputed',
        'Enabled'
        )
        $ADSelect = @(
        'Name',
        'Mail',
        'PasswordLastSet',
        @{n = 'PasswordExpirationDate'; e = {($_.PasswordLastSet).AddDays(90)}},
        @{n = 'PasswordDaysToExpired'; e = {(($_.PasswordLastSet).AddDays(90) - (Get-Date)).Days}}
        )
        $array = @()
       


    }
    Process
    {
        if($Days)
        {

            ForEach($User in $Usernames)
            {
                $User = Get-ADObject -Filter {Name -like $User} 
                
                $User = Get-ADUser -Identity $User -Properties $ADProperties 
                
                
                
                if ($User.Enabled -eq $True -and $User.PasswordNeverExpires -eq $False) 
                {
                        
                        $User = $User | Select-Object -Property $ADSelect
                        
                            if ($User.PasswordDaysToExpired -le $Days)
                            {
                                $props = [pscustomobject]@{
                                Name = $User.name
                                Mail = $User.mail
                                PasswordLastSet = $User.PasswordLastSet
                                PasswordExpirationDate = $User.PasswordExpirationDate
                                PasswordDaysToExpired = $User.PasswordDaysToExpired
                                }   

                                $array += $props
                                
                            }
                            
                            else
                            {
                                Write-Warning "$($User.name) password is expiring in greater than $Days days"

                            }


                }    
                 
                elseif($User.Enabled -eq $TRUE -and $User.PasswordNeverExpires -eq $TRUE)
                {
                    Write-Warning "$($User.name) password is set to never expire"
                }
                elseif($User.Enabled -eq $FALSE)
                {
                    Write-Warning "$($User.name) is disabled"
                }
                else 
                {
                    Write-Warning "$($User.name) was not found in AD!"
                }    
            }   
        } 
        
        else 
        {
            ForEach($User in $Usernames)
            {
                $User = Get-ADObject -Filter {Name -like $User} 
                
                $User = Get-ADUser -Identity $User -Properties $ADProperties 
                
                
                    if ($User.Enabled -eq $True -and $User.PasswordNeverExpires -eq $False) 
                    {
                        
                        $User = $User | Select-Object -Property $ADSelect
                        

                            $props = [pscustomobject]@{
                            Name = $User.name
                            Mail = $User.mail
                            PasswordLastSet = $User.PasswordLastSet
                            PasswordExpirationDate = $User.PasswordExpirationDate
                            PasswordDaysToExpired = $User.PasswordDaysToExpired
                            }   

                            $array += $props
                            



                    }    
                    
                
                    elseif($User.Enabled -eq $TRUE -and $User.PasswordNeverExpires -eq $TRUE)
                    {
                        Write-Warning "$($User.name) password is set to never expire"
                    }
                    elseif($User.Enabled -eq $FALSE)
                    {
                        Write-Warning "$($User.name) is disabled"
                    }
                    else 
                    {
                        Write-Warning "$($User.name) was not found in AD!"
                    }    


            }
        }
    }
    End
    {
        
        
        $array
    }
}