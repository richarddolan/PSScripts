$SiteURL = "https://jhcloud.sharepoint.com/sites/lt/clinicianportalprod/marketing"
$List = "CVs"
Connect-PNPOnline -URL $SiteURL -UseWebLogin
$ListItems = Get-PNPListItem -List $List -PageSize 50
$TimeStamp = "2020-01-27"
##$FilteredItems = $ListItems|Where {$_["Created"] -le "01/27/2020"} 
$FilteredItems = $ListItems|Where {$_["Inactive"] -eq "True"} 
##$FilteredItems|ForEach-Object {Set-PnPListItem -list cvs -id $_["Id"] -Values @{"Inactive" = "True"}}
##$FilteredItems|ForEach-Object {$_["FileLeafRef"],$_["Created"], $_["ID"],$_["Inactive"],$_["UniqueID"],$_["GUID"]}
$FilteredItems|ForEach-Object {$_.FileLeafRef, $_.ID}
Write-Host "Total Items: " $ListItems.count
Write-Host "Total Items: " $FilteredItems.count