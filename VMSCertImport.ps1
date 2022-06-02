#Download the cert & pfx files 
#Use the $env:USERPROFIL to retrieve the user profile path
Invoke-WebRequest -uri <Cert URL> -OutFile "$env:USERPROFILE\JacksonHealthcare.cer"

Invoke-WebRequest -uri <PFX URL> -OutFile "$env:USERPROFILE\JacksonHealthcare.pfx"

#Password in plain text isn't good, the lower option would be better but would require entering the PW 200 times...
$pw = ConvertTo-SecureString "Whatr0ughbeast?" -AsPlainText -Force
##$mypwd = Get-Credential -UserName 'Enter password below' -Message 'Enter password below'
#This imports the certificate into the CurrentUser Personal certificate store. 
#Changing to LocalMachine\My puts it in the localmachine store.
#I have not tested with the cert in the LocalMachine store, though.
Import-Certificate -FilePath "$env:USERPROFILE\JacksonHealthcare.cer" -CertStoreLocation cert:\LocalMachine\My

#Imports the Personal Information Exchange file used with the certificate into the same cert store
Import-PfxCertificate -FilePath "$env:USERPROFILE\JacksonHealthcare.PFX" -CertStoreLocation Cert:\LocalMachine\My -Password $pw