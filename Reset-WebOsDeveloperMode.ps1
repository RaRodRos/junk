function Reset-WebOsDeveloperMode {
	<#
	.SYNOPSIS
		Script to auto reset the webos developer mode in LG televisions
	.NOTES
		The passphrase needs to be already added to the SSH agent or the script will stop to ask for it.
		Requires Send-TelegramBotMsg to send a warning message in case of error
		Based on: https://github.com/webosbrew/dev-goodies/blob/main/reset-devmode-timer.sh
	.ToDo
		- que el script se ejecute cada vez que se reinicie el pc o cada 25 h, lo que pase antes
		- Cambiar la implementación de sendErrorToTelegram por el cmdlet send-telegram
	#>

	[CmdletBinding()]
	param (
		[Parameter(Mandatory = $true)]
		[ValidateNotNullOrEmpty()]
		[string]$Address,

		[string]$User = "prisoner",
		[string]$Port = "9922",
		[string]$SshKeyPath = "${HOME}\.ssh\tv_webos",
		[string]$SessionToken,
		[string]$TelegramToken,
		[string]$TelegramChatId
	)
	
	begin {
		if ([string]::IsNullOrEmpty($sessionToken)) {
			$sessionToken = ssh -i $sshKeyPath -o ConnectTimeout=3 -o StrictHostKeyChecking=no -p $port "$user@$address" cat /var/luna/preferences/devmode_enabled
		}		
	}
	
	process {
		# Telegram warning
		if ([string]::IsNullOrEmpty($sessionToken)) {
			sendErrorToTelegram("Token de sesión vacío")
			return
		}

		$session = ConvertFrom-Json (curl --max-time 3 -s "https://developer.lge.com/secure/ResetDevModeSession.dev?sessionToken=${sessionToken}")
	}
	
	end {
		if ($session.result -ne "success") {
			$msg = "Error extending developer mode in WebOs: `r Error $($session.errorCode): $($session.errorMsg)"
			if ([string]::IsNullOrEmpty($TelegramToken) -or [string]::IsNullOrEmpty($TelegramChatId)) {
				Write-Error $msg
				return
			}
			Send-TelegramBotMsg -Token $TelegramToken -ChatId $TelegramChatId -Message $msg
		}
	}
}