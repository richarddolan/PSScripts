 Enter-PSSession -ComputerName jhadconnectp01 -credential $cred
 Get-ADSyncScheduler
Start-ADSyncSyncCycle -PolicyType Delta
 exit