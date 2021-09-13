if (!($script = $args[0])) {
	$script = 'https://raw.githubusercontent.com/RaRodRos/junk/main/print-jarl.ps1'
}
$script = [Scriptblock]::Create((New-Object System.Net.WebClient).DownloadString($script))
Start-Process powershell.exe -ArgumentList "-ExecutionPolicy Bypass -NoExit -Command $script" -Verb RunAs