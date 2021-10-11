If ($PSCommandPath) { echo $PSCommandPath }
Else {
	$jarl = (New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/RaRodRos/junk/master/print-jarl.ps1')
	echo $jarl
}
