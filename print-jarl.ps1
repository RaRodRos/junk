do {
	If ($PSCommandPath) { echo $PSCommandPath }
	Else { echo ((New-Object System.Net.WebClient).DownloadString("https://raw.githubusercontent.com/RaRodRos/junk/master/print-jarl.ps1")) }
} while ($true)
echo "unreachable"
