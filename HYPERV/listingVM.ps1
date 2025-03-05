$clusterVMs = Get-ClusterGroup | Where-Object {$_.GroupType -eq "VirtualMachine"}

$report = foreach ($vm in $clusterVMs) {
    $vmDetails = Get-VM -ComputerName $vm.OwnerNode.Name | Where-Object Name -eq $vm.Name
    $os = $vmDetails.GuestOperatingSystem

    [PSCustomObject]@{
        VMName         = $vm.Name
        OperatingSystem = $os
    }
}

$report | Format-Table -AutoSize

$report | Export-Csv -Path "C:\scripts\listingVM.csv" -NoTypeInformation