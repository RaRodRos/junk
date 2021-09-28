do {
	echo "jarl"
	$PSCommandPath
	$MyInvocation.MyCommand.Path
} while ($true)
echo "unreachable"
