#title is just the list title, id is the list id & found with get-pnplist

$site = read-host "Enter the site collection URL."
$csv = read-host "Enter the .csv path."

$Lists = import-csv $csv

connect-pnponline -URL $site -useweblogin

foreach ($list in $lists)
{
	write-host $list.title
	$items = Get-PnPListItem -List $list.id -PageSize 1000

	foreach ($item in $items)
	{
		try
		{
			Remove-PnPListItem -List $List.id -Identity $item.Id -Force
			write-host "Library: $($list.title) ID: $($item.id) Removed" -f Green
		}
		catch
		{
			
			write-host "Library: $($list.title) ID: $($item.id) Removed" -f Red
		}
	}
}