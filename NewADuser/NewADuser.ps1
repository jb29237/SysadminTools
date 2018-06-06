<#
.Synopsis
   Used to create new users in Active Directory. For Gsuite commands, module PSGsuite is required
.DESCRIPTION
   This will create users,set the OU to be created in, and put the users in the correct nested groups
.EXAMPLE
   New-ORGADuser -Firstname "Johnny" -Lastname "Test" -Location "LocationNAME" -Title "JobTitle"
#>
function New-ORGADuser
{
    [CmdletBinding(SupportsShouldProcess = $True)]
    
    Param
    (
        # User's first name.
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        [string]$FirstName,

        # User's last name.
        
        [Parameter(Mandatory=$true,
                    ValueFromPipelineByPropertyName=$true,
                    Position=1)]
        [string]$LastName,

        # User's location/department

        [Parameter(Mandatory=$true,
                    ValueFromPipelineByPropertyName=$true,
                    Position=2)]
        [ValidateSet('Accounting','Executive','Facilities','Human Resources','Information Technology',
                     'Marketing')]
        [string]$Location,

        # Job Title/Role which will determine permission groups.

        [Parameter(Mandatory=$true,
                    ValueFromPipelineByPropertyName=$true,
                    Position=3)]
        [ValidateSet('Position1','Position2','Position3')]
        [string]$Title,

        # Default temp password(should be converted to Encrypted CLiXML file)

        [Parameter(Mandatory=$false,
                    ValueFromPipelineByPropertyName=$true,
                    Position=4)]
        [string]$Password = 'yourpassword'
    )
    #Setting all variables to be used
    Begin
    {   
        $GmailGroups = Get-GSGroup
        $Date = Get-Date
        $Logpath = "\\server\folder\log.txt"
        [string]$Email = '@wrongemail.com'
        [string]$UPN = '@domain'
        [string]$OU = "DC=Company,DC=com"
        [string]$GroupIdentity = "Domain Users"
        [string]$FinalUsername = $FirstName[0] + $LastName
        [string]$FinalName = $FirstName + ' ' + $LastName
        [string]$FinalUPN = $FinalUsername + $UPN
        [string]$FinalEmail = 'firstinitiallastname@wrongemail.com'
        [string]$FinalGroupPosition1 = ($location + " "  + "-" + " " + 'Position1')
        [string]$FinalGroupPosition2 = ($location + " "  + "-" + " " + 'Position2')
        [string]$FinalGroupPosition3 = ($location + " "  + "-" + " " + 'Position3')
    }
    Process
    {
        #First switch to set OU and email domain
        Switch ($Location)
        {
            default { Write-Warning "Failed to find $Location"; $Email = '@company.com';} 
            'Accounting' {
                $OU = "OU=Accounting,OU=Administration,OU=Users,OU=MyBusiness,DC=Company,DC=com";
                $Email = '@company.com'
                $GmailOU = '/Administration/Accounting'
            }
            'Executive' {
                $OU = "OU=Executive,OU=Administration,OU=Users,OU=MyBusiness,DC=Company,DC=com"; 
                $Email = '@company.com'
                $GmailOU = '/Administration/Executive'
            }
            'Facilities' {
                $OU = "OU=Facilities,OU=Administration,OU=Users,OU=MyBusiness,DC=Company,DC=com"; 
                $Email = '@company.com'
                $GmailOU = '/Administration/Facilities'
            }
            'Human Resources' {
                $OU = "OU=Human Resources,OU=Administration,OU=Users,OU=MyBusiness,DC=Company,DC=com"; 
                $Email = '@company.com'
                $GmailOU = '/Administration/Human Resources'
            }  
            'Information Technology' {
                $OU = "OU=Information Technology,OU=Administration,OU=Users,OU=MyBusiness,DC=Company,DC=com"; 
                $Email = '@company.com'
                $GmailOU = '/Administration/Information Technology'
            }
            'Marketing' {
                $OU = "OU=Marketing,OU=Administration,OU=Users,OU=MyBusiness,DC=Company,DC=com"; 
                $Email = '@company.com'
                $GmailOU = '/Administration/Marketing'
            }
        }

      
            
            #Initial user creation
            Try
            {
                New-ADUser -Name $FinalName -UserPrincipalName $FinalUPN -SamAccountName $FinalUsername -GivenName $FirstName -DisplayName $FinalName -SurName $LastName -Path $OU -AccountPassword (ConvertTo-SecureString $Password -AsPlainText -force) -Enabled $True -ChangePasswordAtLogon $True
                $log1 = Write-Output "$Date $($FinalName) has been created successfully"
                $log1 | Out-File -FilePath "$Logpath" -Append
                Write-Verbose "$log1"
            }
            Catch
            {
                Write-Warning "$($FirstName + " " + $LastName) FAILED to be created"
                $log2 = Write-Output "$Date $($FinalName) FAILED to be created"
                $log2 | Out-File -FilePath "$Logpath" -Append
                Write-Verbose "$log2"
                break
            }
            #Second switch. Will add users to group based on job title
            Switch ($Title)
            {
                
                default {Write-Warning "Failed to find $Title"}
                'Position1' {
                    $GroupIdentity = Get-ADGroup -Filter {Name -like $FinalGroupStaff} -SearchBase "OU=Security Groups,OU=MyBusiness,DC=Company,DC=com";
                    Add-ADGroupMember -Identity $GroupIdentity -Members $FinalUsername;
                    $FinalEmail = $FinalUsername + $Email
                }
                'Position2' {
                    $GroupIdentity = Get-ADGroup -Filter {Name -like $FinalGroupStaff} -SearchBase "OU=Security Groups,OU=MyBusiness,DC=Company,DC=com";
                    Add-ADGroupMember -Identity $GroupIdentity -Members $FinalUsername; 
                    $FinalEmail = $FinalUsername + $Email
                }
                'Position3' {
                    $GroupIdentity = Get-ADGroup -Filter {Name -like $FinalGroupStaff} -SearchBase "OU=Security Groups,OU=MyBusiness,DC=Company,DC=com";
                    Add-ADGroupMember -Identity $GroupIdentity -Members $FinalUsername; 
                    $FinalEmail = $FinalUsername + $Email
                }
                
            }
            #Used to set User AD properties that were not set during account creation
            try
            {
                $CurrentUser = Get-ADUser -Filter {Name -like $FinalName}
                $CurrentUser | Set-ADUser -EmailAddress $FinalEmail -Company "Hire Date:$(Get-Date)"
                New-GSuser -PrimaryEmail $FinalEmail -GivenName $FirstName -FamilyName $LastName -Password (ConvertTo-SecureString $Password -AsPlainText -force) -ChangePasswordAtNextLogin -OrgUnitPath $GmailOU 
                $FinalGmailGroup = $GmailGroups | Where-Object {($_.Name -like "*$($Location)*") -and ($_.Name -like "*$($Title)*") } | Select-Object Name,Email
                $FinalGmailGroupName = $FinalGmailGroup.Name
                Add-GSGroupMember -Identity $FinalEmail -Member $FinalGmailGroupName 

            }
            catch
            {
                Write-Warning ($FirstName + $LastName) "FAILED to be created"
                $log3 = Write-Output "$Date $($FinalName) FAILED to set $FinalName properties"
                $log3 | Out-File -FilePath "$Logpath" -Append
                Write-Verbose "$log3"
            }
        
     
    }
    #Write final log to central store
    End
    {
            $log4 = Write-Output "$Date $($FinalName) The user $FinalUsername was added to $GroupIdentity successfully. The email is $FinalEmail. The UPN is $FinalUPN"
            $log4 | Out-File -FilePath "$Logpath" -Append
            Write-Verbose "$log4"
    }
}