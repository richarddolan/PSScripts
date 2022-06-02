#Set Variables
$SiteURL = "https://jhcloud.sharepoint.com/PA"
$ListName = "PA%20Marketing%20Team%20Documents"
  
#Connect to PNP Online
Connect-PnPOnline -Url $SiteURL -useweblogin
 
#Get all list items in batches
$ListItems = Get-PnPListItem -List $ListName -PageSize 500
 
#Iterate through each list item
ForEach($ListItem in $ListItems)
{
    #Check if the Item has unique permissions
    $HasUniquePermissions = Get-PnPProperty -ClientObject $ListItem -Property "HasUniqueRoleAssignments"
    If($HasUniquePermissions)
    {       
        $Msg = "Deleting Unique Permissions on {0} '{1}' at {2} " -f $ListItem.FileSystemObjectType,$ListItem.FieldValues["FileLeafRef"],$ListItem.FieldValues["FileRef"]
        Write-host $Msg
        #Delete unique permissions on the list item
        Set-PnPListItemPermission -List $ListName -Identity $ListItem.ID -InheritPermissions
    }
}


#Read more: https://www.sharepointdiary.com/2016/02/powershell-to-delete-unique-permissions-for-all-list-items-sharepoint-online.html#ixzz78dRhaQNw