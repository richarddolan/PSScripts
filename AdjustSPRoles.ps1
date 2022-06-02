<#
This script will need significant adjustment to be usable but gives the cmdlets needed for adjusting permissions. Here are some things to know:
1. Set-PnPListPermission will not work with groups for some reason, so use set-PnPGroupPermissions instead
2. This script assumes that there are multiple columns for each library with users needing access. The IF statement catches blanks
3. The Group statement needs the ID for the list. Use get-pnplist to find IDs for all lists on a site
4. The .csv used originally had Associate (library for ea. associate was the scenario), URL, ID, & Access1-5 with only some of 2-4 containing info
#>
$site = Read-Host "Enter the site collection URL."
$csv = Read-Host "Enter the .csv file path."
$Perms = import-csv $csv
Connect-PnPOnline -Url $site -UseWebLogin

foreach($perm in $perms){
	set-PnPGroupPermissions -identity "LT Gainshare Owners" -List $perm.ID -AddRole "Full Control"
	Set-PnPListPermission -Identity $perm.ID -User $perm.Access1 -RemoveRole 'Contribute'
	Set-PnPListPermission -Identity $perm.ID -User $perm.Access1 -AddRole 'Read'
	Set-PnPListPermission -Identity $perm.ID -User $perm.Access5 -AddRole 'Read'
	IF($perm.Access2){
		Set-PnPListPermission -Identity $perm.ID -User $perm.Access2 -RemoveRole 'Contribute'
		Set-PnPListPermission -Identity $perm.ID -User $perm.Access2 -AddRole 'Read'
	}
	IF($perm.Access3){
		Set-PnPListPermission -Identity $perm.ID -User $perm.Access3 -RemoveRole 'Contribute'
		Set-PnPListPermission -Identity $perm.ID -User $perm.Access3 -AddRole 'Read'
	}
	IF($perm.Access4){
		Set-PnPListPermission -Identity $perm.ID -User $perm.Access4 -RemoveRole 'Contribute'
		Set-PnPListPermission -Identity $perm.ID -User $perm.Access4 -AddRole 'Read'
	}
	write-host $perm.Associate " is done"
}