$VMSusers = get-msoluser -all|? Department -like "VMS*"
Foreach($user in $VMSusers){
	get-msoluser -userprincipalname "$($user.userprincipalname)"|select displayname,@{Name='Licenses';Expression={[string]::join(";",($user.licenses.accountskuid))}}|export-csv VMSLicenses.csv -notypeinformation -append
	}
	

#$licenses = @()
#	$u = "$($user.userprincipalname)"
#	$licenses = $u.licenses.accountskuid
#	if ($licenses -notcontains 'JHCloud:POWER_BI_PRO'){
#		write-host $u