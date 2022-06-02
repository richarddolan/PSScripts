set-location "C:\Users\rdolan\OneDrive - Jackson Healthcare\WindowsPowerShell"
$keypath = "C:\Users\rdolan\OneDrive - Jackson Healthcare\Documents"
$me= "rdolan@jacksonhealthcare.com"
$pw=get-content "$keypath\rdolan.txt"|convertto-securestring
write-host $keypath
$cred=new-object -typename System.Management.Automation.PSCredential -argumentlist $me, $pw

Function Skype
{
import-module lynconlineconnector
$session = new-csonlinesession -credential $cred -verbose
Import-PSSession $session
}

Function O365
{
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $cred -Authentication Basic -AllowRedirection
Import-PSSession $Session
Connect-MSOLService -Credential $Cred
Connect-MicrosoftTeams -Credential $cred
}

Function Lab
{
$user = "rdolan@jhtglab.com"
$LiveCred = Get-Credential -username $user -message "Who?"
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://ps.outlook.com/powershell/ -Credential $LiveCred -Authentication Basic -AllowRedirection
Import-PSSession $Session
Connect-MSOLService -Credential $LiveCred
}

Function o3652
{
$user = "rdolan@jacksonhealthcare.com"
$LiveCred = Get-Credential -username $user -message "Who?"
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://ps.outlook.com/powershell/ -Credential $LiveCred -Authentication Basic -AllowRedirection
Import-PSSession $Session
Connect-MSOLService -Credential $LiveCred
}

Function JTP
{
$user = "okta@jtp.onmicrosoft.com"
$LiveCred = Get-Credential -username $user -message "Who?"
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://ps.outlook.com/powershell/ -Credential $LiveCred -Authentication Basic -AllowRedirection
Import-PSSession $Session
Connect-MSOLService -Credential $LiveCred
}

Function SPO
{
$orgName="jhcloud"
Connect-SpoService -url https://$orgname-admin.sharepoint.com -credential $Cred
}

Function Security
{
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://ps.compliance.protection.outlook.com/powershell-liveid/ -Credential $cred -Authentication Basic -AllowRedirection
Import-PSSession $Session
}

Function Teams
{
Connect-MicrosoftTeams -Credential $cred
}

Function EndSessions
{
$sessions = get-pssession
foreach($Session in $Sessions){Remove-PSSession -Name $Session.Name}
}

Function UserInfo
{Param ($FileName)
get-msoluser | select-object -property UserPrincipalName, FirstName, LastName, DisplayName, JobTitle, Department, OfficeNumber, OfficePhone, MobilePhone, Fax, StreetAddress, City, State,PostalCode,Country | Export-CSV "$FileName"
}

Function AllRules
{
	$users = get-mailbox -resultsize unlimited
	foreach ($user in $users){get-inboxrule -mailbox $user.alias| select-object -property MailboxOwnerId, name}
}

Function CalPerms
{
	$users = get-mailbox -resultsize unlimited
	foreach ($user in $users){$fname=$user.primarysmtpaddress + ":\Calendar" ;get-mailboxfolderpermission $fname | select-object -property Identity, User, AccessRights}
}

Function AddMBRights
{
                $rights = Read-Host 'Which User Gets Rights?'
                $level = Read-Host 'What Permissions?'
                foreach ($right in $rights)
                {Get-Mailbox -ResultSize unlimited -Filter {(RecipientTypeDetails -eq 'UserMailbox')} | Add-MailboxPermission -User $right -AccessRights $level -InheritanceType all}
}

function new-SPOnlineList {
	ServicePointManager.SecurityProtocol = SecurityProtocolType.Tls12


    #variables that needs to be set before starting the script
    $siteURL = "https://jhcloud.sharepoint.com/sites/jc/hr"
    $adminUrl = "https://jhcloud-admin.sharepoint.com"
    $userName = "rdolan@jacksonhealthcare"
    $listTitle = "BusinessPartner"
    $listDescription = "Business Partner"
    $listTemplate = 101
     
    # Let the user fill in their password in the PowerShell window
    $password = Read-Host "Please enter the password for $($userName)" -AsSecureString
     
    # set SharePoint Online credentials
    $SPOCredentials = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($userName, $password)
         
    # Creating client context object
    $context = New-Object Microsoft.SharePoint.Client.ClientContext($siteURL)
    $context.credentials = $SPOCredentials
     
    #create list using ListCreationInformation object (lci)
    $lci = New-Object Microsoft.SharePoint.Client.ListCreationInformation
    $lci.title = $listTitle
    $lci.description = $listDescription
    $lci.TemplateType = $listTemplate
    $list = $context.web.lists.add($lci)
    $context.load($list)
    #send the request containing all operations to the server
    try{
        $context.executeQuery()
        write-host "info: Created $($listTitle)" -foregroundcolor green
    }
    catch{
        write-host "info: $($_.Exception.Message)" -foregroundcolor red
    }  
}
new-SPOnlineList

function CheckInDocument
{
Add-PSSnapin Microsoft.SharePoint.PowerShell
$url="https://jhspp01/sites/thevault2"
$libName="Financials by Company"
$spWeb = Get-SPWeb $url
$getLib = $spWeb.Lists.TryGetList($libName)
$getLib.CheckedOutFiles | ?{ $_.CheckedOutBy.UserLogin.ToLower() -match “Admin’s Network Id”.ToLower()} | %{
$myCheckedOutFile = $_
$myExactFolderName = $myCheckedOutFile.DirName.SubString(13) //This is //to get the exact folder path without the /sites/sitename, this number may //be different for you
$getFolder = $spWeb.GetFolder($myExactFolderName)
$getFolder.Files | Where { $_.CheckOutStatus -ne “None” } | ForEach {
Write-Host “$($_.Name) is Checked out To: $($_.CheckedOutBy)”
$_.CheckIn(“Checked In By Administrator”)
Write-Host “$($_.Name) Checked In” -ForeGroundColor Green
}
}



