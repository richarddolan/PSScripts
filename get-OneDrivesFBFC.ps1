$users = get-mailbox -Filter "EmailAddresses -Like '*@Faithbridge*'"
$sum = @()

#connect-sposervice -url https://jhcloud-admin.sharepoint.com 

foreach($user in $users)
{
	$usr = get-msoluser -userprincipalname $user.primarysmtpaddress -erroraction silentlycontinue
    if ($usr.IsLicensed -eq $true)
    {
        $od4bSC = "https://jhcloud-my.sharepoint.com/personal/$($user.alias)_faithbridgefostercare_org"
		$sc = Get-SPOSite $od4bSC -Detailed -ErrorAction SilentlyContinue | select url, storageusagecurrent, Owner
		$usage = $sc.StorageUsageCurrent / 1024
		$obj=New-Object PSObject  
		$obj|Add-Member @{
			owner = $($sc.Owner)
			url = $($od4bSC)
			size = $($usage)
		}
		$sum+=$obj
    }
}
$sum|export-csv FBFCOneDriveSize.csv -notypeinformation