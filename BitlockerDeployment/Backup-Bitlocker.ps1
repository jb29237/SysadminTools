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
    foreach($Computer in $Computername)
    {
        $status = Get-TPM 
           
        $status 
     
    }

}
function Initialize-ORGTPM
{
    foreach($Computer in $Computername)
    {
            $deploy = Initialize-Tpm  
           
            $deploy 
    }

}
function Backup-ORGBitlocker
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
            $status = Get-ORGTPM 

            if($status.Tpmpresent -eq $False)
            {
                            
              Write-Warning "No TPM detected on $Computer, exiting"
              break
                
            }
            elseif ($status.tpmready -eq $False) 
            {
                Initialize-ORGTPM -Computername $Computer
                continue
            }
            elseif ($status.tpmready -eq $True)
            {
                $volume = Get-BitLockerVolume
                $protectors = $volume.KeyProtectorId

                $keyGUID = $protectors.KeyProtectorId


                Backup-BitLockerKeyProtector -KeyProtectorId $keyGUID
               
                
    
            }  
              
        
        }

    }
    End
    {
        
    }
}