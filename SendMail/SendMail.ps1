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
function Send-ORGMail
{
    [CmdletBinding()]
    Param
    (
        # E-mail addresses of recipients
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   ValueFromPipeline=$true,
                   Position=0)]
        [string[]]$Mail,

        # Path to email template file
        [Parameter(Mandatory=$false,
                   ValueFromPipelineByPropertyName=$true,
                   ValueFromPipeline=$true,
                   Position=1)]
        [string]$Path
    )

    Begin
    {
        $FinalTemplate
        Invoke-Expression ('$FinalTemplate = @"' + "`n" + (get-content "\\server\folder\template.html" |% {$_ + "`n"}) + "`n" + '"@')
        $From = "supportdomain.com"
        $To = $Mail
        $Subject = "Your Windows password is expiring!"
        $SMTPServer = "smtp-relay.email.com"
        $SMTPPort = "1337"
            

    }
    Process
    {
        Foreach ($Address in $Mail)
        {
            Send-MailMessage -To $To -Subject $Subject -From $From -SmtpServer $SMTPServer -BodyasHtml $FinalTemplate


        }


    }
    End
    {



    }
}