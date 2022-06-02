connect-pnponline -url https://jhcloud.sharepoint.com/sites/lt/accounting/gainshare -useweblogin
$data = import-csv gainshare.csv
foreach($list in $data){
	$Groups = @('LT Service Accounts','LT-TS-IMSubs')
	Foreach($Group in $groups){
		set-PnPGroupPermissions -identity $group -List $list.Associate -RemoveRole 'Contribute'
	}
	set-PnPGroupPermissions -identity 'Locum Tenens Members' -List $list.Associate -RemoveRole 'Edit'
	set-PnPGroupPermissions -identity 'Locum Tenens Owners' -List $list.Associate -RemoveRole 'Full Control'
}