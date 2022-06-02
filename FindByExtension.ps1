$site = read-host "Enter the site collection URL."
$extension = read-host "Enter the extension."
$Export = read-host "Enter the .csv name for results."

connect-pnponline -url $site -useweblogin
$libs = get-pnplist|? {$_.basetemplate -eq 101 -and $_.Hidden -eq $false} #Or $_.BaseType -eq "DocumentLibrary"
$results = @()
foreach ($L in $libs){
	$files = get-pnplistitem -list $l -pagesize 500 -Fields "ID"
	foreach($f in $files){
		if($f["FileLeafRef"] -like "*.$extension"){
			$results += [pscustomobject][ordered] @{
			ID =$f["ID"]
			FileName =$f["FileLeafRef"]
			FilePath =$f["FileRef"]
			}
		}
	}
}
$results | export-csv "$Export.csv" -notypeinformation