$worklog = @()

foreach($usr in $(Get-MsolUser -Department shc-operations )) 
 { 
 
	$upn = $usr.UserPrincipalName.Replace(".","_") 
	$newupn = $upn.Replace("@","_")
	$url = "https://jhcloud-my.sharepoint.com/personal/$newupn"
	$url 
	$sc = Get-SPOSite $url -Detailed -ErrorAction SilentlyContinue | select url, storageusagecurrent, Owner 
	 $usage = $sc.StorageUsageCurrent / 1024 
	#return "$($sc.Owner), $($usage), $($url)"
	$worklog = $worklog + [PSCustomObject]@{
				Owner = $sc.Owner
				URL = $sc.url
				Storage = $usage
				} 
	}

 $worklog|export-csv SullivanOneDrive.csv -notypeinformation