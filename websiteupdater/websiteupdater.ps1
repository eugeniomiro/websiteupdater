#
# Script.ps1
#
# Sample command line:
#  .\websiteupdater.ps1 -source D:\eugenio\deploys\Refactor\ -destination D:\eugenio\deploys\PosPre\ [-baseFolderName BACKEND]
#
[CmdletBinding(SupportsShouldProcess=$true)]
param(
	[string] $source,
	[string] $destination,
	[string] $baseFolderName = "FRONTEND"
)

function IsSameContent([byte[]] $firstFile, [byte[]] $secondFile)
{
	$enum1 = $firstFile.GetEnumerator()
    $enum2 = $secondFile.GetEnumerator()    

    while ($enum1.MoveNext() -and $enum2.MoveNext()) {
      if ($enum1.Current -ne $enum2.Current) {
            return $false
      }
    }
    return $true
}

function CreateFolderWithSlots([string] $baseName)
{
	$iteration = 0
	$tentativeFolderName = $baseName
	$foundSlot = $false

	do {		
		if (!$(Test-Path $tentativeFolderName))
		{
			$foundSlot = $true
			Write-Verbose "Backing up to $tentativeFolderName"
		}
		else
		{
			Write-Verbose "$tentativeFolderName already exists"
			$iteration = $iteration + 1
			$tentativeFolderName = "$($baseName)_$iteration"
			Write-Verbose "Switching to $tentativeFolderName"
		}
	} while (!$foundSlot)
	md $tentativeFolderName | Out-Null
	$tentativeFolderName
}

function BackupFiles([string] $source)
{
	Write-Verbose "Backing up $source" 
	
	$backupFolder = CreateFolderWithSlots -baseName "Backup"
	Copy-Item -Path $source -Destination $backupFolder
}

function copy-file-creating-folder-if-needed([string] $source, [string] $destination)
{
	$destinationDir = [system.io.Path]::GetDirectoryName($destination)
	if (!$(Test-Path $destinationDir)) {
		Write-Verbose "creating destinationDir = $destinationDir"
		md $destinationDir | Out-Null
	}
	Write-Verbose "copying $source to $destinationFile"
	Copy-Item -Path $source -Destination $destinationFile -Recurse
}

$frontendFolder = CreateFolderWithSlots -baseName $baseFolderName

echo "new files are in      : $source"
echo "old files are in      : $destination"
echo "destination folder is : $frontendFolder"

Write-Verbose -Message "Building source list..."
$sourceFileList = Get-ChildItem -path $source -Recurse | % { $_.FullName.Replace($source, "") }
Write-Verbose -Message "Source Files`n`t$([System.String]::Join("`n`r`t", $sourceFileList))"
Write-Verbose -Message "found $($sourceFileList.Count) files" 
Write-Verbose -Message ""

Write-Verbose "Building destination list..."
$destinationFileList = Get-ChildItem -path $destination -Recurse | % { $_.FullName.Replace($destination, "") }
Write-Verbose -Message "Destination Files`n`t$([System.String]::Join("`n`r`t", $destinationFileList))"
Write-Verbose -Message "found $($destinationFileList.Count) files" 
Write-Verbose -Message ""

$newFiles = $sourceFileList | where { !$destinationFileList.Contains($_) }
Write-Verbose -Message "Destination Files`n`t$([System.String]::Join("`n`r`t", $newFiles))"
Write-Verbose -Message "found $($newFiles.Count) new files"
Write-Verbose -Message ""

$filesToRemove = $destinationFileList | where { !$sourceFileList.Contains($_) }
Write-Verbose -Message "Files to remove"
Write-Verbose -Message "Destination Files`n`t$([System.String]::Join("`n`r`t", $filesToRemove))"
Write-Verbose -Message "found $($filesToRemove.Count) files to remove"
Write-Verbose -Message ""

Write-Verbose -Message "Comparing similar files..."
$differentFiles = $destinationFileList | 
	where { $sourceFileList.Contains($_) -and $($(Get-Item $(join-Path -Path $source -ChildPath $_)) -isnot [System.IO.DirectoryInfo]) } | 
	where { 
		$allBytesSource      = [System.IO.File]::ReadAllBytes($(join-Path -Path $source -ChildPath $_))
		$allBytesDestination = [System.IO.File]::ReadAllBytes($(join-Path -Path $destination -ChildPath $_))
		!$(IsSameContent -firstFile $allBytesSource -secondFile $allBytesDestination)
	}
Write-Verbose -Message "Destination Files`n`t$([System.String]::Join("`n`r`t", $differentFiles))"
Write-Verbose -Message "found $($differentFiles.Count) different files"
Write-Verbose -Message ""

$filesToRemoveFileName = $(Join-Path -Path $frontendFolder -ChildPath "filesToRemove.txt" )

$stream = [System.IO.StreamWriter] $filesToRemoveFileName
$filesToRemove | ForEach-Object {
	$stream.WriteLine($_)
}
$stream.close()

$newFiles       | % {
	$sourceFile = $(Join-Path -Path $source -ChildPath $_)
	$destinationFile = $(Join-Path -Path $frontendFolder -ChildPath $_)
	copy-File-creating-folder-if-needed -source $sourceFile -destination $destinationFile
}
$differentFiles | % {
	$sourceFile = $(Join-Path -Path $source -ChildPath $_)
	$destinationFile = $(Join-Path -Path $frontendFolder -ChildPath $_)
	copy-File-creating-folder-if-needed -source $sourceFile -destination $destinationFile
}
