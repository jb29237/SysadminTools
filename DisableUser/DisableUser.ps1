<#
.Synopsis
  Funtion that removes user(s) from groups, moves OU, and disables account
.DESCRIPTION
   This function will remove user(s) from all groups, except domain users. It disables the account
   and updates the description with the date at which the account was processed. It then moves them to the 'Deactivated Users' OU.
.EXAMPLE
   Disable-ORGADuser -Username "Johnny Test"
.EXAMPLE
   Disable-ORGADuser "Johnny Test", "Abby Test"
.EXAMPLE
   Get-Content Usernames.txt | Disable-ORGADuser
#>

function Disable-ORGADuser
{
    
    [cmdletbinding(
        SupportsShouldProcess = $True
    )]
    Param
    (
        [parameter(
            Position=0, 
            Mandatory=$true, 
            ValueFromPipeline=$true
        )]
        [string[]]$Usernames
    )
    
    
    Begin
    {
        
        $date = Get-Date
        $old_error = $ErrorActionPreference
        $file_path = "\\server\folder\log.txt"
    }

    Process
    {
       
        Foreach($U in $Usernames)
        {
            $Suser = Get-ADuser -Filter 'Name -like $U' -SearchBase ("OU=MyBusiness,DC=SLST,DC=local")
            if ($Suser.Enabled -eq $True)  
            { 
                $ErrorActionPreference = 'SilentlyContinue'
                
                $Ugroups = Get-ADPrincipalGroupMembership $Suser

                    Foreach($g in $Ugroups)
                    {
                       
                   
                        try 
                        {

                            Remove-ADPrincipalGroupMembership -Identity $Suser -MemberOf $g -Confirm:$False
                    
                            $log1 = Write-Output "$date Removed from Group $($g.Name)"
                            $log1 | Out-File -FilePath $file_path -Append
                            Write-Verbose "$log1"
                                
                        }
                        
                        
                        catch 
                        {
                            $log1catch = Write-Output "$date FAILED to remove from Group $($g.Name)"
                            $log1catch | Out-File -FilePath $file_path -Append
                            Write-Verbose "$log1catch"
                            continue
                                
                        }
                            
                    }
                $ErrorActionPreference = $old_error
                Disable-ADAccount -Identity $Suser
                $log2 = Write-Output "$date $($Suser.Name) Has been disabled"
                $log2 | Out-File -FilePath $file_path -Append
                Write-Verbose "$log2"
                Set-ADUser -Identity $Suser -Description "$date $($Suser.Name)"
                
                Move-ADObject $Suser -TargetPath "OU=Deactivated Users,OU=Users,OU=MyBusiness,DC=company,DC=com" 
            }
          
            elseif ($Suser.Enabled -eq $False)
            {

                $log4 = Write-Output "$($Suser.name) is already disabled"
                $log4 | Out-File -FilePath $file_path -Append
                Write-Verbose "$log4"
            }
        
    
        }    
    }

}