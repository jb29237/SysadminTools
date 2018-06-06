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
function Get-ORGTPM
{
    [CmdletBinding()]
    Param
    (
        # Param1 help description
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        [string[]]$Computername

       
    )

    Begin
    {   

    }
    Process
    {
        foreach ($Computer in $Computername)
        {
            $status = Get-TPM 
           
            $status 
        
        }

    }
    End
    {
        
    }
}