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
function Update-ORGModule
{
    [CmdletBinding()]
    Param
    (
        # Param1 help description
        [Parameter(Mandatory=$false,
                   ValueFromPipeline=$true,
                   Position=0)]
        $Module

       
    )

    Begin
    {
        $Module = Copy-Item -Path "$($Env:USERPROFILE)\Documents\Powershell\Modules\ORGcommands.psm1" -Destination "$($Env:USERPROFILE)\Documents\WindowsPowershell\Modules\ORGcommands\ORGcommands.psm1"


    }
    Process
    {



    }
    End
    {



    }
}