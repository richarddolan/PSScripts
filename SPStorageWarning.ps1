$url = 'https://jhcloud-admin.sharepoint.com'

#Specify a folder path to output the results into
$path = '.\'

#SMTP details
$Smtp = 'smtp.office365.com'
$From = 'rdolan@jacksonhealthcare.com'  
$To = 'rdolan@jacksonhealthcare.com'
$Subject = 'Site Storage Warning'  
$Body = 'Storage Usage Details'

if($url -eq '') {
  $url = Read-Host -Prompt 'Enter the SharePoint admin center URL'
}

#Connect-SPOService -Url $url
Connect-PNPOnline -Url $url -UseWebLogin

#Local variable to create and store output file  
$filename = (Get-Date -Format o | foreach {$_ -Replace ":", ""})+'.csv'  
$fullpath = $path+$filename

#Enumerating all sites and calculating storage usage  
$sites = Get-SPOSite -Limit ALL
$results = @()

foreach ($site in $sites) {
  $siteStorage = New-Object PSObject
  if ($site.StorageQuota -gt 0)
  {
  $percent = $site.StorageUsageCurrent / $site.StorageQuota * 100  
  $percentage = [math]::Round($percent,2)
	if ($percentage -ge 35)
	{
	  $siteStorage | Add-Member -MemberType NoteProperty -Name "Site Title" -Value $site.Title
	  $siteStorage | Add-Member -MemberType NoteProperty -Name "Site Url" -Value $site.Url
	  $siteStorage | Add-Member -MemberType NoteProperty -Name "Percentage Used" -Value $percentage
	  $siteStorage | Add-Member -MemberType NoteProperty -Name "Storage Used (MB)" -Value $site.StorageUsageCurrent
	  $siteStorage | Add-Member -MemberType NoteProperty -Name "Storage Quota (MB)" -Value $site.StorageQuota
	  $siteStorage | Add-Member -MemberType NoteProperty -Name "Priority" -Value "P1"

	  $results += $siteStorage
	  $siteStorage = $null
	 } elseif ($percentage -ge 25)
	 {
	  $siteStorage | Add-Member -MemberType NoteProperty -Name "Site Title" -Value $site.Title
	  $siteStorage | Add-Member -MemberType NoteProperty -Name "Site Url" -Value $site.Url
	  $siteStorage | Add-Member -MemberType NoteProperty -Name "Percentage Used" -Value $percentage
	  $siteStorage | Add-Member -MemberType NoteProperty -Name "Storage Used (MB)" -Value $site.StorageUsageCurrent
	  $siteStorage | Add-Member -MemberType NoteProperty -Name "Storage Quota (MB)" -Value $site.StorageQuota
	  $siteStorage | Add-Member -MemberType NoteProperty -Name "Priority" -Value "P3"

	  $results += $siteStorage
	  $siteStorage = $null
	 }
   }
}

$results | Export-Csv -Path $fullpath -NoTypeInformation

#Sending email with output file as attachment  
Send-MailMessage -SmtpServer $Smtp -To $To -From $From -Subject $Subject -Attachments $fullpath -Body $Body -Priority high -Credential $cred -Port 587 -UseSsl