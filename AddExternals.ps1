$site = "https://jhcloud.sharepoint.com/sites/jhbusinesscontinuity"

connect-pnponline -url $site -useweblogin
$lists = import-csv .\bclibraries.csv

foreach($list in $lists){
	Try{ 
		get-pnpuser -identity $list.access1
	}
	Catch{
		Add-PnPUserToGroup -Identity BCExternals -EmailAddress $list.access1
		Set-PnPListPermission -Identity $list.ID -EmailAddress $list.Access1 -AddRole 'Contribute'
		}
}