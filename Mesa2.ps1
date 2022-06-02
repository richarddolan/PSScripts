$siteURL = "https://jhcloud-my.sharepoint.com/personal/smesa_jacksonandcoker_com"
 
$list = "Documents"
 
Connect-PNPOnline -URL $SiteURL -UseWebLogin
 
$csvArray = @()
 
$getItems = (Get-PNPListItem -List $list -Fields "FileLeafRef", "FileRef", "Created" -PageSize 500).FieldValues
 
Foreach ($item in $getItems)
    {
        $csvArray += $item.ID,$item.FileLeafRef,$item.Created,$item.FileRef
    }
 
$csvArray | export-csv -Path "C:\Users\rdolan\OneDrive - Jackson Healthcare\Documents\Mesa.csv" -NoTypeInformation