New-Item -Path C:\inetpub\wwwroot\master -ItemType Directory
$zipfilename = 'C:\master.zip'
$destination = 'C:\inetpub\wwwroot\master'

function UnZipMe($zipfilename, $destination) {
$shellApplication = new-object -com shell.application
$zipPackage = $shellApplication.NameSpace($zipfilename)
$destinationFolder = $shellApplication.NameSpace($destination)
$destinationFolder.CopyHere($zipPackage.Items(),20)
}
UnZipMe -zipfilename "c:\master.zip" -destination "C:\inetpub\wwwroot\master"

$name = "master"

Import-Module WebAdministration
sleep 2
Set-ItemProperty IIS:\AppPools\$name managedRuntimeVersion v4.0
$site = Get-WebSite | where { $_.Name -eq $name }
if($site -eq $null)
{
 Write-Host "Creating site: $name $destination" -force 

 # TODO:
 New-WebSite $name -Force
 New-WebApplication -Site $name -Name $name -PhysicalPath "C:\inetpub\wwwroot\master" -ApplicationPool $name
}

