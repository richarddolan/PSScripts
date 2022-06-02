$site = Read-Host "Enter the site collection URL."
$csv = Read-Host "Enter the .csv file path."

Connect-PnPOnline -URL $site -useweblogin

$tags = import-csv $csv
ForEach($Tag in $Tags){Set-PnPListItem -List "TeamInfo" -Identity $tag.ID -Values @{"Tag" = $Tag.Tag; "Title" = $Tag.Name}}