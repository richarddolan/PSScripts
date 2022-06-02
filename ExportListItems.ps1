###### Declare and Initialize Variables ######  
$url="https://jhcloud.sharepoint.com/sites/lt/clinicianportalprod/marketing"
$listName="CVs"  
$currentTime= $(get-date).ToString("yyyyMMddHHmmss")  
$logFilePath=".\MktgLog-"+$currentTime+".docx"  
# Fields that has to be retrieved  
$Global:selectProperties=@("FileLeafRef","ID","Created");  
 
## Start the Transcript  
Start-Transcript -Path $logFilePath   
 
 
## Export List to CSV ##  
function ExportList  
{  
    try  
    {  
        # Get all list items using PnP cmdlet  
        $listItems=(Get-PnPListItem -List $listName -Fields $Global:selectProperties -pagesize 500).FieldValues  
        $outputFilePath=".\MktgResults-"+$currentTime+".csv"  
  
        $hashTable=@()  
 
        # Loop through the list items  
        foreach($listItem in $listItems)  
        {  
            $obj=New-Object PSObject              
            $listItem.GetEnumerator() | Where-Object { $_.Key -in $Global:selectProperties }| ForEach-Object{ $obj | Add-Member Noteproperty $_.Key $_.Value}  
            $hashTable+=$obj;  
            $obj=$null;  
        }  
  
        $hashtable | export-csv $outputFilePath -NoTypeInformation  
     }  
     catch [Exception]  
     {  
        $ErrorMessage = $_.Exception.Message         
        Write-Host "Error: $ErrorMessage" -ForegroundColor Red          
     }  
}  
 
## Connect to SharePoint Online site  
Connect-PnPOnline -Url $url -UseWebLogin  
 
## Call the Function  
ExportList  
 
## Disconnect the context  
Disconnect-PnPOnline  
 
## Stop Transcript  
Stop-Transcript  
