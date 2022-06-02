$SiteURL = "https://jhcloud-my.sharepoint.com/personal/smesa_jacksonandcoker_com"
$List = "Documents"
Connect-PNPOnline -URL $SiteURL -UseWebLogin
##$listItems = Get-PNPListItem -List $List -PageSize 500
(Get-PNPListItem -List $list -Fields "FileLeafRef", "FileRef", "Created" -PageSize 500).FieldValues#|export-csv -Path "C:\Users\rdolan\OneDrive - Jackson Healthcare\Documents\Mesa.csv" -NoTypeInformation
##$ListItems|ForEach-Object {$_["ID"],$_["FileLeafRef"],$_["Created"], $_["FileRef"]}
##Write-Host "Total Items: " $ListItems.count
