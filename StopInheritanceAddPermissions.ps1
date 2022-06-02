connect-pnponline -url https://jhcloud.sharepoint.com/sites/lt/accounting/gainshare -useweblogin
$data = import-csv gainshare.csv
foreach($list in $data){
	$l = get-pnplist $list.id
	$l.breakroleinheritance($false,$false)
	set-pnplistpermission -identity $list.id -user $list.Access1 -AddRole 'Contribute'
	}
	
	