Add-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools -IncludeAllSubFeature
Add-WindowsFeature -Name DNS -IncludeManagementTools -IncludeAllSubFeature
$CreateDnsDelegation = $false
$DomainName = "insertdomain.lan"
$NetbiosName = "ADRARFORMATION"
$NTDSPath = "C:\Windows\NTDS"
$LogPath = "C:\Windows\NTDS"
$SysvolPath = "C:\Windows\SYSVOL"
$DomainMode = "Default"
$InstallDNS = $true
$ForestMode = "Default"
$NoRebootOnCompletion = $false
$SafeModeClearPassword = "InsertYourAdminPassword"
$SafeModeAdministratorPassword = ConvertTo-SecureString $SafeModeClearPassword -AsPlaintext -Force
Install-ADDSForest -CreateDnsDelegation:$CreateDnsDelegation -DomainName $DomainName -DatabasePath $NTDSPath -DomainMode $DomainMode -DomainNetbiosName $NetbiosName -ForestMode $ForestMode -InstallDNS:$InstallDNS -LogPath $LogPath -NoRebootOnCompletion:$NoRebootOnCompletion -SysvolPath $SysvolPath -SafeModeAdministratorPassword $SafeModeAdministratorPassword -Force:$true