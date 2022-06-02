#Load SharePoint Online Assemblies
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.dll"
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.Runtime.dll"
 
#Remove Group from List Permissions
Function Remove-SPOGroupFromListPermission($SiteURL,$ListName,$GroupName)
{
    #Setup Credentials to connect
    $Cred = Get-Credential
    $Cred = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($Cred.UserName,$Cred.Password)
  
    Try {
        #Setup the context
        $Ctx = New-Object Microsoft.SharePoint.Client.ClientContext($SiteURL)
        $Ctx.Credentials = $Cred
      
        #Get the List
        $List=$Ctx.Web.Lists.GetByTitle($ListName)
        $Ctx.Load($List)
        $Ctx.ExecuteQuery()
         
        #Get the Group
        $Group = $Ctx.Web.SiteGroups.GetByName($GroupName) 
        $Ctx.Load($Group)
        $Ctx.ExecuteQuery()
  
        #Break Permission Inheritance
        $List.BreakRoleInheritance($true, $false)
        $Ctx.ExecuteQuery()
 
        #Get List Permissions
        $Ctx.Load($List.RoleAssignments)
        $ctx.ExecuteQuery()
         
        #Remove Group from List Permissions
        $List.RoleAssignments.GetByPrincipal($Group).DeleteObject()
        $Ctx.ExecuteQuery()
  
        write-host  -f Green "Group '$GroupName' has been Removed from List '$ListName'"
    }
    Catch {
        write-host -f Red "Error:" $_.Exception.Message
    }
}
 
#Variables for Processing
$SiteURL = "https://jhcloud.sharepoint.com/sites/lt/accounting/gainshare"
$ListName = "Chris Franklin"
$GroupName = "Locum Tenens Members"
  
#Call the function to Remove group from SharePoint List permissions
Remove-SPOGroupFromListPermission -SiteURL $SiteURL -ListName $ListName -GroupName $GroupName