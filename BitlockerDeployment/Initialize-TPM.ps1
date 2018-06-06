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
function Initialize-ORGTPM
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
            $deploy = Initialize-Tpm  
           
            $deploy 
        
        }

    }
    End
    {
        
    }
}