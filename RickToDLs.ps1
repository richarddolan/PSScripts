
# Change the two paths below for the new senders and the DLs you want to add them to.
$Sender = "jackson"
$DLs = Get-DistributionGroup -resultsize unlimited|? {$_.acceptmessagesonlyfrom -ne ""}
# Run through the groups you want to modify and filter out any users or groups that already have permissions to send...
ForEach ($DL in $DLs) {
    $DLToAmend = Get-DistributionGroup $DL
    "INFO: Detecting duplicates that already have permission to send to $($DLToAmend.DisplayName)..."
    # Checking 
           If (($DLToAmend).AcceptMessagesOnlyFromSendersOrMembers -contains $Sender) {
            "INFO: $Sender is already able to send to $($DLToAmend.DisplayName). Filtering out..."
        } Else {
            $SendersToAddFiltered = $Sender
        }
   
    # Displaying who will be added...
    "INFO: $($SendersToAddFiltered.Count) new sender(s) will be configured to send to $($DLToAmend.DisplayName)..."
    If ($SendersToAddFiltered.Count -ne 0) {
        "INFO: The senders to be added are:"
        $SendersToAddFiltered
    }

    #Now for the actual command...
    If ($SendersToAddFiltered.Count -eq 0) {
        "INFO: No need to run the command as there is nothing to add..."
    } Else {
        "INFO: Adding users/groups to allowed senders for $($DLToAmend.DisplayName)..."
        Set-DistributionGroup $DLToAmend -AcceptMessagesOnlyFromSendersOrMembers(($DLToAmend).AcceptMessagesOnlyFromSendersOrMembers + $SendersToAddFiltered)
    }
    $SendersToAddFiltered = @()
}
$SendersToAdd = @()