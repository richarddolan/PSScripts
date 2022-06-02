<#
Assumes a csv file with GivenName, SurName, ParentOU, and Password.
Be sure to enclose the ParentOU in double quotes (b/c there are commas in there)
#>

Import-Module ActiveDirectory
$file = read-host "What is the path & name of the .csv with the users?"
$users = import-csv $file
Foreach($user in $users){
	$sam = $user.givenname + $user.SurName
	$UPN = $sam + "@jhs-dev.local"
	New-ADUser -name $sam -GivenName $user.GivenName -SurName $user.SurName -userprincipalname $UPN -samAccountName $sam -AccountPassword (ConvertTo-SecureString $user.password -AsPlainText -Force) -Path $user.ParentOU -ChangePasswordAtLogon $true -Enabled $true
	}
		