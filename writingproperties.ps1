$SiteURL = "https://jhcloud.sharepoint.com/sites/lt/clientdocumentsprod"
$Lists = import-csv demo.csv

#connect-pnponline -URL $siteURL -useweblogin

foreach ($list in $lists)
{
	write-host $list.title
	$items = Get-PnPListItem -List $list.id -Fields "ID","FileLeafRef","GUID","Name" -PageSize 1000

	foreach ($item in $items)
	{
		try
		{
			#$File = (Get-PNPListItem -List $list.id -Id $item.id -Fields "FileLeafRef" -PageSize 1).fieldvalues
			write-host "Library: $($list.title) File: $($item.FileLeafRef) $($item.name) ID: $($item.id) Removed" -f Green
		}
		catch
		{
			Write-Host $list.title + $item " error" -f Red
		}
	}
}