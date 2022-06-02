$array1 = get-content jcasources.txt
$array2 = get-content jcadestinations.txt
$array3 = get-content jcacompares.txt
$combinedfiles = @()

	for($index=0;$index -lt $array1.Count;$index++){ 
		$combinedfiles += New-Object psobject -Property @{
		$array1[$index]
		$array2[$index]
		$array3[$index]}
		}

write-host $combinedfiles