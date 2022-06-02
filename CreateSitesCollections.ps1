#Title is a friendly name, path is what comes after the site collection URL. STS#0 is the classic site template

$site = read-host "Enter the site collection URL."
$csv = read-host "Enter the .csv path."

connect-pnponline -url $site -useweblogin
$sites = import-csv $csv
foreach($site in $sites){
	New-PnPWeb -Title $site.Title -url $site.Path -Template STS#0 
	Write-Host "Created "$site.Title
}