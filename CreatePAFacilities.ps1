connect-pnponline -url https://jhcloud.sharepoint.com/sites/pa/facilities -useweblogin
$lists = import-csv PAFacilities.csv
write-host "List Imported"
foreach($list in $lists){
	New-PnPList -Title $List.Title -url $list.URL -Template DocumentLibrary 
	Write-Host "Created "$list.Title
}


