#connect-pnponline -url https://jhcloud.sharepoint.com/sites/lt
$sites = get-pnpsubwebs -recurse
foreach($site in $sites){
	$web = Get-PnPWeb -id $site.id -Includes RoleAssignments
	foreach($ra in $web.RoleAssignments) {
		$member = $ra.Member
		$loginName = get-pnpproperty -ClientObject $member -Property LoginName
		$rolebindings = get-pnpproperty -ClientObject $ra -Property RoleDefinitionBindings
		#write-host "$($web.title) - $($loginName) - $($rolebindings.Name)"
		$InfoObj = New-Object PSObject
		$InfoObj|Add-Member NoteProperty -Name "Site" -Value $web.title
		$InfoObj|Add-Member NoteProperty -Name "User or Group" -Value $loginName
		$InfoObj|Add-Member NoteProperty -Name "Role" -Value $rolebindings.Name
		$output = [Array]$output + $InfoObj		
	}
}
$output|export-csv LTAllThePerms.csv -notypeinformation