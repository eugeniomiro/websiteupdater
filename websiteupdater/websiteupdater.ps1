#
# Script.ps1
#
# Sample command line:
#  .\websiteupdater.ps1 -source D:\eugenio\deploys\Refactor\ -destination D:\eugenio\deploys\PosPre\ 
#
param(
	[string] $source,
	[string] $destination
)

function IsSameContent($firstFile, $secondFile)
{
	$i = 0
	if ($firstFile.length -ne $secondFile.length) {
		$false
		return
	}
	while($i -lt $firstFile.length) {
		if ($firstFile[$i] -ne $secondFile[$i]) {
			$false
			return
		}
		$i++
	}
	$true
}

echo "source is      : $source"
echo "destination is : $destination"

echo "Building source list..."
$sourceFileList = Get-ChildItem -path $source -Recurse | % { $_.FullName.Replace($source, "") }
echo "found $($sourceFileList.Count) files" 

echo "Building destination list..."
$destinationFileList = Get-ChildItem -path $destination -Recurse | % { $_.FullName.Replace($destination, "") }
echo "found $($destinationFileList.Count) files" 

$newFiles = $sourceFileList | where { !$destinationFileList.Contains($_) }
echo "found $($newFiles.Count) new files"
$newFiles

$removedFiles = $destinationFileList | where { !$sourceFileList.Contains($_) }
echo "found $($removedFiles.Count) removed files"
$removedFiles

$differentFiles = $destinationFileList | 
	where { $sourceFileList.Contains($_) -and $($(Get-Item $(join-Path -Path $source -ChildPath $_)) -isnot [System.IO.DirectoryInfo]) } | 
	where { 
		$allBytesSource = [System.IO.File]::ReadAllBytes($(join-Path -Path $source -ChildPath $_))
		$allBytesDestination = [System.IO.File]::ReadAllBytes($(join-Path -Path $destination -ChildPath $_))
		!$(IsSameContent -firstFile $allBytesSource -secondFile $allBytesDestination)
	}

	#where { Compare-Object -ReferenceObject (Get-Content $(join-Path -Path $source -ChildPath $_)) -DifferenceObject (Get-Content $(Join-Path -Path $destination -ChildPath $_)) }
	#where { 
	#	Write-Host $_;
	#	$result = $(Get-Item $(join-Path -Path $source -ChildPath $_)) -isnot [System.IO.DirectoryInfo] -and `
	#			  ($(Get-Content $(join-Path -Path $source -ChildPath $_)) -eq $(Get-Content $(Join-Path -Path $destination -ChildPath $_)))
	#	$result
	#}
$differentFiles
echo "found $($differentFiles.Count) different files"


echo "Backing up destination"