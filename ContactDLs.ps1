 $collection = @()
    $contacts = import-csv PDContacts.csv
    
    ForEach($contact in $contacts) {
        
        $DN=$contact.DistinguishedName
        $Filter = "Members -like '$DN'"
        $groups = Get-DistributionGroup -ResultSize unlimited -Filter $Filter
        $outObject = "" | Select "Full Name","Email","Groups"
        $outObject."Full Name" = $contact.DisplayName
        $outObject."Email" = $contact.PrimarySMTPAddress
        $outObject."Groups" = $groups
        $collection += $outObject
    }
    $collection | Out-GridView
    Remove-Variable * -ErrorAction SilentlyContinue