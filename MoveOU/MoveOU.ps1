<#
.Synopsis
   Moves a User to a new OU in AD
.DESCRIPTION
   Takes multi-string input of usernames and moves the object to a new OU in AD.
.EXAMPLE
   Move-ORGOU -Usernames "Johnny Test" -OU "New Users"
.EXAMPLE
   Move-ORGOU "Johnny Test" "New Users"
.EXAMPLE
    Move-ORGOU "Johnny Test","Abby Test" "New Users"
.EXAMPLE
    Get-Content Usernames.txt | Move-ORGOU -OU "New Users"
#>
function Move-ORGOU
{
    [CmdletBinding()]
       Param
    (
        # Param1 help description
        [Parameter(Mandatory=$true,
                   ValueFromPipeline=$true,
                   Position=0)]
        [string[]]$Usernames,
        [Parameter(Mandatory=$true,
                   ValueFromPipeline=$true,
                   Position=1)]
        $OU

        
    )

    Begin
    {
        $OU = Get-ADOrganizationalUnit -Filter ("Name -like '$OU'")
       
        
    }
    Process
    {
        foreach($User in $Usernames)
        {
            $User = Get-ADObject -Filter {Name -like $User}

            if ($User) 
            {
                # Move to proper OU
                Move-ADObject -Identity $User -TargetPath ($OU | Select-Object -ExpandProperty DistinguishedName)
                Write-Output "$($User.name) has been moved to... `n $OU"
            } 
            else 
            {
                # User not found--print an error
                Write-Output "$Usernames was not found in AD!"
            }

        }
        
    }


    
    End
    {



    }
}