$item = 'd:\jackson"&"harris'
$params = New-Object System.Collections.Arraylist
$params.AddRange(@("/L","/S","/NJH","/BYTES","/FP","/NC","/NDL","/TS","/XJ","/R:0","/W:0"))
$countPattern = "^\s{3}Files\s:\s+(?<Count>\d+).*"
$sizePattern = "^\s{3}Bytes\s:\s+(?<Size>\d+(?:\.?\d+)\s[a-z]?).*"
((robocopy $item NULL $params)) | ForEach {
    If ($_ -match "(?<Size>\d+)\s(?<Date>\S+\s\S+)\s+(?<FullName>.*)") {
        New-Object PSObject -Property @{
            FullName = $matches.FullName
            Size = $matches.Size
            Date = [datetime]$matches.Date
        }
    } Else {
        Write-Verbose ("{0}" -f $_)
    }
}