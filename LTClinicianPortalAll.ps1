connect-pnponline -Url https://jhcloud.sharepoint.com/sites/lt/ -UseWebLogin
$groups = get-pnpgroup
ForEach($Group in $Groups){
	$members = Get-PnPGroupMembers -Identity $Group.Id
	ForEach ($member in $members){
		$InfoObj = New-Object PSObject
		$InfoObj|Add-Member NoteProperty -Name "SP Group" -Value $Group.Title
		$InfoObj|Add-Member NoteProperty -Name "SP Group ID" -Value $Group.ID
		$InfoObj|Add-Member NoteProperty -Name "User" -Value $member.Title
		$InfoObj|Add-Member NoteProperty -Name "Email" -Value $member.Email
		$InfoObj|Add-Member NoteProperty -Name "UserID" -Value $member.ID
		$output = [Array]$output + $InfoObj
	}
}
$output|export-csv LTClinPortalUsers.csv -notypeinformation