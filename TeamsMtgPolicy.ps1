##Connect to Services - if you don't store credentials in your PS Profile, uncomment the first line
#$cred = get-credential
connect-msolservice -credential $cred
skype
connect-microsoftteams -credential $cred 

##Get CL Users
$users = Get-MsolUser -all |? {$_.userprincipalname -like "*@carelogistics.com"}

##Determine if Has Restricted Anonymous Policy and adjust to global default
foreach ($user in $users)
{$Policy = Get-CsUserPolicyassignment -user $user.userprincipalname -policytype TeamsMeetingPolicy
If ($Policy.PolicyName -eq "RestrictedAnonymousAccess"){
write-host "Updating" $user.userprincipalname
Grant-CsTeamsMeetingPolicy -identity $user.userprincipalname -PolicyName $null}
Else {write-host $user.userprincipalname  "has policy"  $policy.policyname}
}