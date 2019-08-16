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

echo "source is      : $source"
echo "destination is : $destination"

echo "Building source list..."
$sourceFileList = Get-ChildItem -path $source -Recurse | % { $_.FullName.Replace($source, "") }
echo "found $($sourceFileList.Count) files" 

echo "Building destination list..."
$destinationFileList = Get-ChildItem -path $destination -Recurse | % { $_.FullName.Replace($destination, "") }
echo "found $($destinationFileList.Count) files" 

echo "Backing up destination"