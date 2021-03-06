$vcenter = "atlprodvc01.jhs.local"
$cluster = "JH-Production"

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
                $VMView = $vm | Get-View
                $VMSummary = "" | Select ClusterName,HostName,VMName,VMSockets,VMCores,CPUSockets,CPUCores,VMMem
                $VMSummary.VMName = $vm.Name
                $VMSummary.VMSockets = $VMView.Config.Hardware.NumCpu
                $VMSummary.VMCores = $VMView.Config.Hardware.NumCoresPerSocket
                $VMSummary.VMMem = $VMView.Config.Hardware.MemoryMB

                $vminfo += $VMSummary
            }

$TotalStorage = ($datastore | Measure-Object -Property CapacityMB -Sum).Sum / 1024
$AvailableStorage = ($datastore | Measure-Object -Property FreeSpaceMB -Sum).Sum / 1024
$NumofVMs = $vminfo.Count
$NumofVMCPUs = ($vminfo | Measure-Object -Property "VMSockets" -Sum).Sum
$NumofHostCPUs = ($hostinfo | Measure-Object -Property "CPUCores" -Sum).Sum
$HostVM2coreRatio = $NumofVMCPUs / $NumofHostCPUs
$TotalHostRAM = ($hostinfo | Measure-Object -Property "MemorySizeGB" -Sum).Sum / 1024
$TotalVMRAM = ($vminfo | Measure-Object -Property "VMMem" -Sum).Sum / 1024 / 1024
$NumOfHosts = $hostinfo.count
$NumOfHostsSockets = ($hostinfo | Measure-Object -Property "CPUSockets" -Sum).Sum

## This section is where you paste the code output by powerBI
$endpoint = "https://api.powerbi.com/beta/8f1328c8-5ddd-42b4-8308-60ea7e68cb37/datasets/f9584acb-b547-4b6a-bea5-39e05e26bd59/rows?key=btEMpbbpNmGanhZm8qGvSqH3G85foNC7xvNP%2FDCaBAbkIsRRt7Ukm31wHEkfeJOb%2FyAxb%2BpuygJ%2FlQuJBkNQxw%3D%3D"
$payload = @{
"Date" =$date
"Total Storage" =$TotalStorage
"Available Storage" =$AvailableStorage
#"HostVersion" = 
"NumofVMS" =$NumofVMs
"NumofHostCPUs" =$NumofHostCPUs
"HostVM2coreRatio" =$HostVM2coreRatio
"TotalHostRAM" =$TotalHostRAM
"TotalVMRAM" =$TotalVMRAM
"NumOfHosts" =$NumOfHosts
"NumOfHostsSockets" =$NumOfHostsSockets
}
Invoke-RestMethod -Method Post -Uri "$endpoint" -Body (ConvertTo-Json @($payload))