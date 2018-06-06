<#
.Synopsis
   Short description
.DESCRIPTION
   Long description
.EXAMPLE
   Example of how to use this cmdlet
.EXAMPLE
   Another example of how to use this cmdlet
#>
function Set-ORGEmployeeID
{
    [CmdletBinding(
        SupportsShouldProcess= $True
    )]
    Param
    (
        # Param1 help description
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        [string[]]$Username,

        # Param2 help description
        [Parameter(Mandatory=$true,
                    ValueFromPipelineByPropertyName=$true,
                    Position=1)]
        [string]$EmployeeID
    )

    Begin
    {


    }
    Process
    {
        Foreach($user in $username)
        {
            $getuser = Get-ADuser -Filter 'Name -like $User' -SearchBase ("OU=MyBusiness,DC=Company,DC=com")
            Set-ADUser -Identity $getuser -EmployeeID $EmployeeID
        }

    }
    End
    {


    }
}