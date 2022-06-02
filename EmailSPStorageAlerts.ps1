$url = 'https://jhcloud-admin.sharepoint.com'

#SMTP details
$Smtp = 'smtp.office365.com'
$From = 'rdolan@jacksonhealthcare.com'  
$To = 'R02B1STJ9MSMNVJ2JF1AC2XT60LK1ZKZ@jacksonhealthcare.pagerduty.com'
$Subject = 'Site Storage Warning'  
$Body = 'Storage Usage Details'

if($url -eq '') {
  $url = Read-Host -Prompt 'Enter the SharePoint admin center URL'
}

Connect-SPOService -Url $url -credential $cred

#Enumerating all sites 
$sites = Get-SPOSite -Limit ALL

foreach ($site in $sites) {
  $siteStorage = New-Object PSObject
  if ($site.StorageQuota -gt 0)
  {
  #Calculating storage usage  
  $Used = $site.StorageUsageCurrent/1024
  $GBUsed = [math]::Round($Used,2)
  
  $Quota = $site.StorageQuota/1024
  $GBQuota = [math]::Round($Quota,2)
  
  $percent = $site.StorageUsageCurrent / $site.StorageQuota * 100  
  $percentage = [math]::Round($percent,2)
	if ($percentage -ge 90)
	{
		$Subject = ("P1: " + $site.Title + " is " + $percentage + "% of capacity")
		$Body = ("Site URL is " + $site.URL + " " + $GBUsed + "GB of " + $GBQuota + "GB used.")
		
		Send-MailMessage -SmtpServer $Smtp -To $To -From $From -Subject $Subject -Body $Body -Priority high -Credential $cred -Port 587 -UseSsl
	 } elseif ($percentage -ge 70)
	 {
	  $Subject = ("P3: " + $site.Title + " is " + $percentage + "% of capacity")
		$Body = ("Site URL is " + $site.URL + " " + $GBUsed + "GB of " + $GBQuota + "GB used.")
		
		Send-MailMessage -SmtpServer $Smtp -To $To -From $From -Subject $Subject -Body $Body -Credential $cred -Port 587 -UseSsl
	  }
   }
}

