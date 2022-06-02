#Initiate an array to log the results
$worklog = @()

$year = 2010

#Paths to skip
$skips = ('\\Clients|\\JPS Marketing Department|\\MARKETING\\Endorsed Partners|\\Admin\\Alli\\Contracts|\\Recruitment Manual|\\RFPs and Proposals|\\Specialty Demographics|\\Training Documents|\\Reference Forms\\Reference Letters|\\Academic and Leadership Reference Letters|\\Business Development Marketing Collaterals|\\Business Development Training|\\archive')

while ($year -le 2019){
#Get all of the files for the year, will change to LastAccessTime when live
Try{
$Files=Get-ChildItem -path '\\jhs-file-server\AccountingShared\LT\AccountsReceivable\1Staff\Invoices' -recurse|? {$_.lastwritetime -ge "$year-01-01" -and $_.lastwritetime -le "$year-12-31" -and $_.fullname -notmatch $skips} -ErrorAction Stop
#\\lt_fileserv\d$\Jackson&Harris\
#Moves the files to the appropriate archive year
foreach($File in $Files){
	
		#Create a log entry so that we can back out if we have to
		$worklog = $worklog + [PSCustomObject]@{
			ArchiveYear = $year
			OriginalPath = $File.fullname
			DestinationPath = "\\lt_fileserv\d$\Jackson&Harris\\archive\$year"
			LastAccessed = $File.LastAccessTime
			Moved = $true
		}
		write-host "Moved $File" -foregroundcolor Green
	}
	
}
Catch{
		$worklog = $worklog + [PSCustomObject]@{
			ArchiveYear = ''
			OriginalPath = $File.Fullname
			DestinationPath = ''
			LastAccessed = $File.LastAccessTime
			Moved = $false
		}
		write-host "Didn't move $File.Fullname" -foregroundcolor Red
	}
#Happy New Year!
$year++
}
#Export the log
$worklog|export-csv FilesMoved.csv -notypeinformation