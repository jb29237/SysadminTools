
function Get-ORGCurrentUser {
[CmdletBinding()]
param (
[Parameter(Mandatory=$True)]
[string[]]$computername
)

foreach ($pc in $computername){
$logged_in = (Get-WMIObject win32_computersystem -COMPUTER $pc).username
$name = $logged_in.split("\")[1]
"{0}: {1}" -f $pc,$name
}
}