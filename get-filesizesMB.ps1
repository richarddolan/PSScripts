$path = read-host "Enter the path to read from.""
$output = read-host "Enter the name and location for the export."

GCI $path -Force -Recurse|Select-Object fullname, @{Name="MegaBytes";Expression={"{0:f2}"-f ($_.length/1MB)}}, CreationTime, LastAccessTime, LastWriteTime|Export-CSV $output -notypeinformation