Function New-Email
{
	[CmdletBinding()]
	Param ( 
	[Parameter(Mandatory=$true)]
	[ValidateNotNullOrEmpty()][string]$To,

	[Parameter(Mandatory=$true)]
	[ValidateNotNullOrEmpty()][string]$From,

	[Parameter(Mandatory=$true)]
	[ValidateNotNullOrEmpty()][string]$Subject,

	[Parameter(Mandatory=$true)]
	[ValidateNotNullOrEmpty()][string]$Body,

	[Parameter(Mandatory=$true)]
	[ValidateNotNullOrEmpty()][string]$SMTP,
		
	[Parameter(Mandatory=$false)]
	[string]$Cc,

	[Parameter(Mandatory=$false)]
	[string]$AttachmentFilename
	)

	Begin
	{
		Write-Verbose 'Creating SMTP client and mail message objects.'
		$SmtpClient = New-Object System.Net.Mail.SmtpClient
		$MailMessage = New-Object System.Net.Mail.Mailmessage
	}

	Process
	{
		write-verbose "Adding properties to mail message and sending email"
		if ($AttachmentFilename -ne $null -and $AttachmentFilename.Length -gt 0)
		{
			try
			{
				$Attachment = New-Object System.Net.Mail.Attachment($AttachmentFilename)
				$MailMessage.Attachments.Add($Attachment)
				Write-Verbose "Attachment file found: $AttachmentFilename"
			}
			catch [System.Exception]
			{
				Write-Warning "You must provide the full filename! File $AttachmentFilename NOT found!"
				BREAK;
			}
		}
		else
		{
			Write-Verbose "No attachments were specified."
		}

		try
		{
			$SmtpClient.host = "$SMTP"
			$MailMessage.IsBodyHtml = 1
			$MailMessage.From = ("$From")
			$MailMessage.To.Add("$To")
			$MailMessage.Cc.Add("$CC")
			$MailMessage.Subject = "$Subject"
			$MailMessage.Body = $Body
			$SmtpClient.Send($MailMessage)
		}
		catch [System.Exception]
		{
      BREAK;
		}
	}
	
	End
	{
		write-verbose "The email was sent successfully."
	}
}
