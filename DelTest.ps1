$SiteURL = "https://jhcloud.sharepoint.com/sites/lt/clientdocumentsprod"


connect-pnponline -URL $siteURL -useweblogin


	$items =Get-PnPListItem -List "Agreement" -PageSize 1000

	foreach ($item in $items)
	{
		try
		{
			Remove-PnPListItem -List "Agreement" -Identity $item.Id -Force
			write-host $item.title -f DarkGreen
		}
		catch
		{
			Write-Host "error " $item.title.tostring() -f Red
		}
	}
