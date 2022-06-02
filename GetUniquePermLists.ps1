#Function to Get Lists and Libraries with Unique Permission from a Site collection
Function Get-UniquePermissionLists($SiteURL)
{
    #Connect to SharePoint Online Site from PnP Online
    Connect-PnPOnline -Url $SiteURL -UseWebLogin
    $Web = Get-PnPWeb
	$results =@()
    #Function to Get Lists with Unique Permissions from the web
    Function Get-PnPUniquePermissionLists($Web)
    {
        #Write-host "Searching Lists and Libraries with Unique Permissions at:"$Web.Url -f Yellow
        #Get All Lists from the web
        $Lists = Get-PnPList -Includes HasUniqueRoleAssignments
     
        #Exclude system lists
        $ExcludedLists = @("Content and Structure Reports","Form Templates","Images","Pages","Preservation Hold Library", "Site Pages", "Site Assets",
                             "Site Collection Documents", "Site Collection Images","Style Library","Reusable Content","Workflow History","Workflow Tasks")
               
        #Iterate through lists
        ForEach($List in $Lists)
        {
            #Filter Lists - Exclude System Lists, hiddenlists and get only lists with unique permissions
            If($List.Hidden -eq $False -and $ExcludedLists -notcontains $List.Title -and $List.HasUniqueRoleAssignments)
            {
			    Write-host "`tFound a List '$($List.Title)' with Unique Permission at '$($List.RootFolder.ServerRelativeUrl)'" -f Green
			$Results += @(
			[pscustomobject]@{
				Title=$List.Title
				Address=$List.RootFolder.ServerRelativeUrl}
			)
			}
        }
    }
	write-host $results
	
	#export the results
    $results|export-csv "PA-UniquePermissions.csv" -notypeinformation
	#Call the function for Root Web
    Get-PnPUniquePermissionLists($Web)
 
    #Call the function for all subsites
    Get-PnPSubWebs -Recurse | ForEach-Object {
        Get-PnPUniquePermissionLists($_)
    }
 }
 
#Call the function
Get-UniquePermissionLists "https://jhcloud.sharepoint.com/sites/pa"