$memberFile = Read-Host "Enter the group member .csv path"
$site = Read-Host "Enter the site URL"

$members = import-csv $memberFile

Connect-PnPOnline -url $site -useweblogin

#Add Group members
foreach($member in $members)
{
	Add-PnPUserToGroup -LoginName $member.PrimarySmtpAddress -Identity $member.Group
}