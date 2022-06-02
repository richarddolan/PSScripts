Connect-PnPOnline -ClientId d97e0eb8-bcec-4eac-8168-323f455448ce -thumbprint "7EB1E7ADDEE74FD83EC55887E67F129FCA07E624" -Url https://jhcloud.sharepoint.com/sites/VMS/Software -Tenant "JHCloud.onmicrosoft.com"

#You can get the profile path for the file with "$env.USERPROFILE/<SomeFileName.xxx>"
Get-PnPOnlineFile -url '/Downloads/<SomeFileName.xxx>' -path <some path> -AsFile

#Put code to do the rest of the things here
#You can call an msi 
#Start-Process msiexec.exe -Wait -ArgumentList '/I "$env.USERPROFILE/<SomeFileName.xxx>" /quiet' -Wait
#You can also run an exe
#Invoke-Command -ComputerName $env:Name -ScriptBlock {Start-Process "$env.USERPROFILE/<SomeFileName.xxx>" -ArgumentList '/silent' -Wait}