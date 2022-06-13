$vcenter = "atlprodvc01.jhs.local"
$cluster = "JH-Production"
$ID = 0

Import-Module VMware.VimAutomation.Core
Connect-VIServer -Server $vcenter -credential $cred

#This line passes creds to the proxy for auth.  If you dont have a PITA proxy, comment out.
#[System.Net.WebRequest]::DefaultWebProxy.Credentials = [System.Net.CredentialCache]::DefaultCredentials

$date = Get-Date
$datastore = Get-Cluster -Name $cluster | Get-Datastore | Where-Object {$_.Type -eq 'VMFS' -and $_.Extensiondata.Summary.MultipleHostAccess}

$hostinfo = @()
        ForEach ($vmhost in (Get-Cluster -Name $cluster | Get-VMHost))
        {
            $HostView = $VMhost | Get-View
                        $HostSummary = "" | Select HostName, ClusterName, MemorySizeGB, CPUSockets, CPUCores, Version
                        $HostSummary.HostName = $VMhost.Name
                        $HostSummary.MemorySizeGB = $HostView.hardware.memorysize / 1024Mb
                        $HostSummary.CPUSockets = $HostView.hardware.cpuinfo.numCpuPackages
                        $HostSummary.CPUCores = $HostView.hardware.cpuinfo.numCpuCores
                        $HostSummary.Version = $HostView.Config.Product.Build
                        $hostinfo += $HostSummary
                    }

$vminfo = @()
            foreach($vm in (Get-Cluster -Name $cluster | Get-VM))
        {
                $IP = get-vm -Name $vm|select @{n="IP";E={@($_.guest.ipaddress[0])}}
				
				$VMView = $vm | Get-View
                $VMSummary = "" | Select ID, VMName, ClusterName,HostName, VMIP, VMGuestOS,VMSockets,VMCores,CPUSockets,CPUCores,VMMem, VMPowerState, VMNumCPUs, VMMemoryGB, VMNotes, VMUsedStorage, VMProvisionedStorage
				
				$VMSummary.ID = $ID
                $VMSummary.VMName = $vm.Name
				$VMSummary.ClusterName = $cluster
				$VMSummary.VMGuestOS = $VMView.config.guestFullName
                $VMSummary.VMSockets = $VMView.Config.Hardware.NumCpu
                $VMSummary.VMCores = $VMView.Config.Hardware.NumCoresPerSocket
                $VMSummary.VMMem = $VMView.Config.Hardware.MemoryMB
				$VMSummary.VMPowerState = $vm.PowerState
				$VMSummary.VMNumCPUs = $vm.NumCpu
				$VMSummary.VMMemoryGB = $vm.MemoryGB
				$VMSummary.VMNotes = $vm.Notes
				$VMSummary.VMUsedStorage=$vm.UsedSpaceGB
				$VMSummary.VMProvisionedStorage = $vm.ProvisionedSpaceGB
				$VMSummary.VMIP = "$($IP[0].IP)"
				

                $vminfo += $VMSummary
				$ID = $ID+1
            }
$Params = @{
	'DataSetID' = '18ce1e5b-ddd6-4412-ab5d-a63a9ac94214'
	'TableName' = 'VMs'
	'Rows' = $vminfo
	'WorkspaceId' = '13d135c6-1ad3-40ec-8f37-3a3829735003'
}
Connect-PowerBIServiceAccount -Credential $cred

Add-PowerBIRow -datasetid '18ce1e5b-ddd6-4412-ab5d-a63a9ac94214' -TableName 'VMs' -Rows $vminfo -workspaceid '13d135c6-1ad3-40ec-8f37-3a3829735003'

<#
#$vminfo|export-csv ProdMachines.csv -notypeinfo
#$hostinfo|export-csv ProdHosts.csv -notypeinfo
foreach($vmi in $vminfo)
{
	
$endpoint = "https://api.powerbi.com/beta/8f1328c8-5ddd-42b4-8308-60ea7e68cb37/datasets/149cd147-51a4-4f49-b96d-647a12fb41a8/rows?key=4sjhWe%2BrB%2FXCul8lq3X%2Fa8U2NjDG27ruKurk9CzOCKpQkH%2B1goOn5zcZlbQsqGUKwQhUBr9V9VSkotwXmVJERA%3D%3D"
$payload = @{
"VMName" = $Vmi.VMName
"ClusterName" =$vmi.ClusterName
"GuestOS" =$vmi.VMGuestOS
"Sockets" =$vmi.VMSockets
"Cores" =$vmi.VMCores
"Memory" =$vmi.VMMemoryGB
"PowerState" =$vmi.VMPowerState
"CPUs" =$vmi.VMNumCPUs
"UsedStorage" =$vmi.VMUsedStorage
"ProvisionedStorage" =$vmi.VMProvisionedStorage
"IPAddress" =$vmi.VMIP
"Notes" =$vmi.VMNotes
}
Invoke-RestMethod -Method Post -Uri "$endpoint" -Body (ConvertTo-Json @($payload))
}
#>