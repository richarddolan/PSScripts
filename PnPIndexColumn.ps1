#Config Variables
$SiteURL = "https://jhcloud.sharepoint.com/sites/lt/clinicianportalprod/customercare"
$Lists = import-csv LTCCLibraries.csv
$ColumnName = "FileLeafRef" #Internal Name
 
#Connect to PNP Online
Connect-PnPOnline -Url $SiteURL -useweblogin
 
foreach($List in $lists){
#Get the Field from List
$Field = Get-PnPField -List $($List.library) -Identity $ColumnName
 
#Set the Indexed Property of the Field
$Field.Indexed = $True
$Field.Update() 
}

