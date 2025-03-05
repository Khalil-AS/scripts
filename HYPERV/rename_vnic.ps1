
Get-VMNetworkAdapter -VMName client_test01
Get-VMNetworkAdapterVlan -vmname firewall01

Rename-VMNetworkAdapter -VMName client_test01 -Name 'Carte réseau'-NewName eth0

Set-VMNetworkAdaptervlan -VMName firewall01 -VMNetworkAdapterName "Eth1"-Trunk -AllowedVlanIdList "50,100" -NativeVlanId 1
Set-VMNetworkAdaptervlan -VMName firewall01 -VMNetworkAdapterName "Eth1"-Untagged


# RENAME NET ADAPTER INCREMENTAL
$NewNames = @("eth0", "eth1", "eth2")  # Remplacez ces noms par ceux que vous souhaitez
$VMName = "firewall01"  # Remplacez par le nom de votre machine virtuelle
$VM = Get-VM -Name $VMName
$VMNetworkAdapters = Get-VMNetworkAdapter -VM $VM
for ($i = 0; $i -lt $VMNetworkAdapters.Count; $i++) {
    $NewName = $NewNames[$i]
    Rename-VMNetworkAdapter -VMNetworkAdapter $VMNetworkAdapters[$i] -NewName $NewName
}