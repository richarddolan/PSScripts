#Initiate an array to log the results
$worklog = @()

#Create a folder for each year to archive
$year = 2010
while ($year -le 2019){
md "C:\Users\rdolan\WindowsPowerShell\archive\$year"
$year++}

#Reset the Year
$year = 2010

#Paths to skip
$skips = ('\\Clients|\\JPS Marketing Department|\\MARKETING|\\Admin|\\Recruitment Manual|\\RFPs and Proposals|\\Specialty Demographics|\\Training Documents|\\Reference Forms\\Reference Letters|\\Academic and Leadership Reference Letters|\\Business Development Marketing Collaterals|\\Business Development Training|\\El Paso Childrens|\\archive')


while ($year -le 2019){
#Get all of the files for the year, will change to LastAccessTime when live
$Files=Get-ChildItem -path '\\lt_fileserv\d$\Jackson&Harris\' -recurse|? {$_.lastaccesstime -ge "$year-01-01" -and $_.lastaccesstime -le "$year-12-31" -and $_.fullname -notmatch $skips}

#Moves the files to the appropriate archive year
foreach($File in $Files){
	Try{
		Move-Item -Path $File.fullname -destination "\\lt_fileserv\d$\Jackson&Harris\archive\$year" -ErrorAction Stop
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
}
#Happy New Year!
$year++
}
#Export the log
$worklog|export-csv FilesMoved.csv -notypeinformation