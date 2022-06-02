#Connect to Azure AD
connect-azuread

#Get the user to change e.g. for user@kirbybatesassociates477.com, enter user
$OldUPN = read-host "What's the current UPN prefix?"

#Find the real objectid
$ObjectID = get-azureaduser -objectid "$($OldUPN)@kirbybatesassociates477.onmicrosoft.com"

#Update the user and document the change
Set-AzureADUser -objectid $objectid.objectid -immutableid $objectid.objectid -userprincipalname "$($OldUPN)@kirbybates.com"
Write-host "Created User " $objectid.userprincipalname


