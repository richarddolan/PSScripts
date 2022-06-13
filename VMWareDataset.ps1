
$ID = get-powerbiworkspace -name 'jhtg - dccd'|select ID

$Columns =@()

$ColumnMap = @{
	"ID" = 'Int64'
	"VMName" = 'string'
	"ClusterName" = 'string'
	"GuestOS" = 'string'
	"Sockets" = 'Int64'
	"Cores" = 'Int64'
	"Memory" = 'Int64'
	"PowerState" = 'string'
	"CPUs" = 'Int64'
	"UsedStorage" = 'string'
	"ProvisionedStorage" = 'string'
	"IPAddress" = 'string'
	"Notes" = 'string'
}

$ColumnMap.GetEnumerator()|ForEach-Object{
	$Columns += New-PowerBiColumn -Name $_.Key -DataType $_.Value
}

$Table = New-PowerBiTable -Name 'VMs' -Columns $Columns
$DataSet = New-PowerBiDataSet -Name 'VMTable' -Tables $Table

$DataSetResult = Add-PowerBIDataSet -DataSet $DataSet -WorkspaceID $ID.ID