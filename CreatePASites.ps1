connect-pnponline -url https://jhcloud.sharepoint.com/sites/pa -useweblogin
$sites = import-csv PASites.csv
foreach($site in $sites){
	New-PnPWeb -Title $site.Title -url $site.Path -Template STS#0 
	Write-Host "Created "$site.Title
}