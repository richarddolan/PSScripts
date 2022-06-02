connect-pnponline -url https://jhcloud.sharepoint.com -useweblogin
$user = 806
$sites = get-pnptenantsite
foreach($site in $sites){
	connect-pnponline -url $site.url -useweblogin
	write-host $site.url
	$web = get-pnpweb
	$Web.getusereffectivepermissions($user)
	}