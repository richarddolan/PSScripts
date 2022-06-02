$cred = get-credential
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://ps.outlook.com/powershell/ -Credential $Cred -Authentication Basic -AllowRedirection
Import-PSSession $Session
get-mailbox |select userprincipalname, primarysmtpaddress|export-csv UPNandEmail.csv -notypeinformation