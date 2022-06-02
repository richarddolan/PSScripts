$users = get-mailbox -Filter "EmailAddresses -Like '*@Faithbridge*'"
$sum = @()
foreach ($user in $users)
	{
		$size = get-mailboxstatistics -identity $user.identity
		$obj=New-Object PSObject  
		$obj|Add-Member @{
			size = $size.totalitemsize
			
			user = $user.identity
		}
		$sum+=$obj
	}
$sum|export-csv FBFCSize.csv -notypeinformation