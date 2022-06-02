$items = gci -path "." -recurse
$output =@()
foreach($item in $items){
	$ls=(Get-ACL -Path .).access| select IdentityReference,FileSystemRights,AccessControlType,IsInherited,InheritanceFlags
	foreach ($l in $ls){
		$output = $output + [PSCustomObject]@{
			Item = $item.FullName
			Identity = $l.IdentityReference
			Rights = $l.FileSystemRights
			AccessControlType = $l.AccessControlType
			IsInherited = $l.IsInherited
			InheritanceFlags = $l.InheritanceFlags
		}	
	}
}
$output|export-csv TestPerms.csv -notypeinformation