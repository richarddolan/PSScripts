#The csv needs 2 columns. The first is a friendly displayname (Title) and the second is the name for the URL. No spaces is best.
$site = read-host "Enter the site collection URL."
$csv = read-host "Enter the .csv path."

connect-pnponline -url $site -useweblogin
$lists = import-csv $csv
write-host "List Imported"
foreach($list in $lists){
	New-PnPList -Title $List.Title -url $list.URL -Template DocumentLibrary 
	Write-Host "Created "$list.Title
}


