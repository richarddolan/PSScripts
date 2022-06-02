#The csv needs 2 columns. The first is a friendly displayname (Title) and the second is the name for the URL. No spaces is best.
$site = "https://jhcloud.sharepoint.com/sites/jhbusinesscontinuity"
$csv = read-host "Enter the .csv path."
connect-pnponline -url $site -useweblogin
$lists = import-csv $csv

foreach($list in $lists){
	Set-PnPList -Identity $List.ID -BreakRoleInheritance -CopyRoleAssignments
	Set-PnPListPermission -Identity $list.ID -EmailAddress $list.Access1 -AddRole 'Contribute'
	IF($list.Access2){
		Set-PnPListPermission -Identity $list.ID -User $list.Access2 -AddRole 'Contribute'
	}
	IF($list.Access3){
		Set-PnPListPermission -Identity $list.ID -User $list.Access3 -AddRole 'Contribute'
	}
	IF($list.Access4){
		Set-PnPListPermission -Identity $list.ID -User $list.Access4 -AddRole 'Contribute'
	}
		IF($list.Access5){
		Set-PnPListPermission -Identity $list.ID -User $list.Access5 -AddRole 'Contribute'
	}
		IF($list.Access6){
		Set-PnPListPermission -Identity $list.ID -User $list.Access6 -AddRole 'Contribute'
	}
		IF($list.Access7){
		Set-PnPListPermission -Identity $list.ID -User $list.Access7 -AddRole 'Contribute'
	}
		IF($list.Access8){
		Set-PnPListPermission -Identity $list.ID -User $list.Access8 -AddRole 'Contribute'
	}
	write-host $list.title " is done"
}