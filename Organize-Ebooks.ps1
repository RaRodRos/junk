#####
# Organize ebook files with similar names in folders and give them the same title
#####

# Checks if there are a valid path passed as argument
# Specifies a path to one or more locations.

param (
	[string]$Path = $PSScriptRoot,
	# if $Multi is $true, the program will search IN the folders contained INSIDE $Path
	[bool]$Multi = $False
)
if (!(Test-Path $Path -PathType Container)) { throw "Wrong directory path" }

# Get title from metadata using exiftool
function Get-MetaTitle ($File, $DeleteChars) {
	if ($title = & exiftool -t -q -q -title $file.FullName) {
		if (!$deleteChars) {
			$deleteChars = "[$([Regex]::Escape(-join [System.Io.Path]::GetInvalidFileNameChars()))]"
		}
		return ($title.Replace("Title", "") -Replace $deleteChars, "").Trim()
	}
}
# Remove empty folders
function deleteEmptyFolders ([string]$ArgPath) {
	foreach ($childDirectory in Get-ChildItem -Force -LiteralPath $ArgPath -Directory) {
		deleteEmptyFolders($childDirectory.FullName)
	}
	$currentFolder = Get-ChildItem -Force -LiteralPath $ArgPath
	if (!$currentFolder) {
		Write-Verbose "Removing empty folder at path '${ArgPath}'." -Verbose
		Remove-Item -Force -LiteralPath $ArgPath
	}
}

Set-Variable -Name illegalChars -Value ([string]"[$([Regex]::Escape(-join [System.Io.Path]::GetInvalidFileNameChars()))]") -Option Constant
if ($Multi) {
	$bundles = Get-ChildItem -LiteralPath $Path -Directory
}
else {
	$bundles = @(Get-Item -LiteralPath $Path)
}
$count = $bundles.Count

for ($i = 0; $i -lt $count; $i++) {
	# Arraylist with all ebook files in the target path
	Write-Verbose "Ordering bundle $($i+1) of $count ($($bundles[$i].Name))" -Verbose
	[System.Collections.ArrayList]$unfilteredFiles = 
	Get-ChildItem -Path $bundles[$i] -File -Recurse |
	Where-Object -Property Extension -Match "pdf|epub|mobi" |
	Sort-Object -Property { $_.baseName.Length }
	
	while ($unfilteredFiles.Count -gt 0) {
		# Take the last file, save it's name and remove it from $unfilteredFiles
		$sameBookFiles = [System.Collections.ArrayList]@()
		$targetFolder = $bundles[$i]
		$sameBookFiles.Add($unfilteredFiles[0])
		$unfilteredFiles.RemoveAt(0)
		
	}
}





# probarlo en iOS _ Android Mobile Development by Packt


function Get-NameArrays ($listaCompleta) {
	$arraySeleccionados = [System.Collections.ArrayList]@()
	:exterior while ($listaCompleta.Count -gt 0) {
		foreach ($innerArray in $arraySeleccionados) {
			if ($listaCompleta[0].BaseName -match $innerArray[0].BaseName) {
				$innerArray.add($item)
				$listaCompleta.RemoveAt(0)
				continue exterior
			}
		}
		$arraySeleccionados.add([System.Collections.ArrayList]@($listaCompleta[0]))
		$listaCompleta.RemoveAt(0)
	}
	return $arraySeleccionados
}
Function recurse($Array) {
	$title = ""
	$titulados = [System.Collections.ArrayList]@()
	$noTitulados = [System.Collections.ArrayList]@()

	foreach ($item in $Array) {
		if ($item -is [array] -or $item -is [System.Collections.ArrayList]) {
			recurse($item)
			if ($item.Count -eq 0) { $Array.Remove($item) }
		}
	}

	$smallerName = $Array[0].Basename
	while ($Array.Count -gt 0) {
		if ($currentTitle = Get-MetaTitle -File $Array[$Array.Count] -DeleteChars $illegalChars) {
			if (!$title) { $title = $currentTitle }
			$titulados.Add((Rename-Item -Path $Array[$Array.Count] -NewName $currentTitle -PassThru))
		}
		else { $noTitulados.Add($Array[$Array.Count]) }
		$Array.RemoveAt($Array.Count)
	}

	$targetFolder = Join-Path -Path $bundles[$i] -ChildPath $smallerName
	if ($title) {
		foreach ($item in $noTitulados) {
			$currentTitle = $item.BaseName.Replace($smallerName, $title) + $item.Extension
			$titulados.Add((Rename-Item -Path $item -NewName $currentTitle -PassThru))
		}
		$targetFolder = Join-Path -Path $bundles[$i] -ChildPath $Title
	}

	if (!(Test-Path $targetFolder -PathType Container)) {
		$targetFolder = New-Item -Path $targetFolder -ItemType Directory
	}
	foreach ($item in $noTitulados) {
		Move-Item -Path $item -Destination $targetFolder
	}
	foreach ($item in $titulados) {
		Move-Item -Path $item -Destination $targetFolder
	}
}


Write-Verbose "Moving $($item.BaseName)" -Verbose




deleteEmptyFolders($Path)