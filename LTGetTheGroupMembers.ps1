#connect-azuread
$groups = import-csv LTSPGroupList.csv
ForEach($g in $Groups){
	write-host $g.group
	$group = get-azureadgroup -searchstring $g.Group
	write-host $group.objectid
	$members = Get-AzureADGroupMember -ObjectID $Group.ObjectID
	ForEach ($member in $members){
		$InfoObj = New-Object PSObject
		$InfoObj|Add-Member NoteProperty -Name "List" -Value $Group.DisplayName
		$InfoObj|Add-Member NoteProperty -Name "ListID" -Value $Group.ObjectID
		$InfoObj|Add-Member NoteProperty -Name "User" -Value $member.DisplayName
		$InfoObj|Add-Member NoteProperty -Name "UPN" -Value $member.UserPrincipalName
		$InfoObj|Add-Member NoteProperty -Name "UserID" -Value $member.ObjectID
		$output = [Array]$output + $InfoObj
	}
}
$output|export-csv LTADUsersAndGroups.csv -notypeinformation