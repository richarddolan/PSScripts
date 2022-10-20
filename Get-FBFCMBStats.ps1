 $MBs = Import-Csv "C:\Users\rdolan\OneDrive - Jackson Healthcare\FBFC_Mailboxes.csv"
 $output =@()
 ForEach($MB in $MBs){$stat=Get-EXOMailboxStatistics -UserPrincipalName $MB.UPN -ErrorAction SilentlyContinue
		$output = $output + [PSCustomObject]@{
			User = $stat.DisplayName
			ItemCount = $stat.ItemCount
			Size = $stat.TotalItemSize
		}	
	}
$output|export-csv FBFCSizes.csv -notypeinformation
 
 
