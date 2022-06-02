#Load SharePoint CSOM Assemblies
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.dll"
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.Runtime.dll"

#Function to Move a File
Function MoveSPOFile
{
param ([String]$SiteURL, [String]$SourceFileURL, [String]$TargetFileURL)
write-host -f Blue $SourceFileURL
write-host -f DarkBlue $TargetFileURL
Try{
#Setup the context
$Ctx = New-Object Microsoft.SharePoint.Client.ClientContext($SiteURL)
$Ctx.Credentials = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials("rdolan@jacksonhealthcare.com", $PW)
#sharepoint online powershell to move files
$MoveCopyOpt = New-Object Microsoft.SharePoint.Client.MoveCopyOptions
$Overwrite = $True
[Microsoft.SharePoint.Client.MoveCopyUtil]::MoveFile($Ctx, "$SourceFileURL", "$TargetFileURL", $Overwrite, $MoveCopyOpt)
$Ctx.ExecuteQuery()
Write-host -f Green "File Moved Successfully!"
}
Catch {
write-host -f Red "Error Moving "$SourceFileURL $_.Exception.Message
}
}

#Get Credentials to connectim
$PW= Read-Host -Prompt "PW" -AsSecureString

#Set Config Parameters
$Files=import-csv jcamovetotraining.csv
$SiteURL="https://jhcloud.sharepoint.com/"

foreach($file in $files){
$SourceFileURL=$($file.Source) #need full URL not relative for this & below
$TargetFileURL=$($file.Destination)

#Call the function to Move the File
IF ($file.Type -eq "Item"){MoveSPOFile $SiteURL $SourceFileURL $TargetFileURL}
}