$LTSites = Get-PnPTenantSite -filter "URL -like '/teams/lt'" -Detailed
$output =@()
foreach($LT in $LTSites){ 
		$output = $output + [PSCustomObject]@{
			Site =  $LT.url
			Usage = $LT.StorageUsagecurrent
			
		}	
	}
$output|export-csv LTTeamsStorage.csv -notypeinformation