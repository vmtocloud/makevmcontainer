#!/usr/bin/pwsh
<#
    .NOTES
    ===========================================================================
	 Created by:   	Ryan Kelly
     Date:          August 24th, 2019
	 Organization: 	VMware
     Blog:          vmtocloud.com
     Twitter:       @vmtocloud
    ===========================================================================
#>

# ------------- VARIABLES SECTION - EDIT THE VARIABLES BELOW ------------- 
$vCenter = “vcenter.sddc-34-194-236-229.vmwarevmc.com“
$vCenterUser = “cloudadmin@vmc.local“
$vCenterPassword = 'changeme'
$ResourcePool = “Compute-ResourcePool“
$Datastore = “WorkloadDatastore“
$DestinationFolder = “RKELLY“
$Template = “CentOS7-RKelly“
$VMName = “rkellycentos“
# ------------- END VARIABLES - DO NOT EDIT BELOW THIS LINE ------------- 

# Connect to VMC vCenter Server
Set-PowerCLIConfiguration -InvalidCertificateAction:Ignore -Confirm:$false
$VCConn = Connect-VIServer -Server $vCenter -User $vCenterUser -Password $vCenterPassword
New-VM -Name “$VMName“ -Template $Template -ResourcePool $ResourcePool -Datastore $datastore -Location $DestinationFolder
Start-Sleep -Seconds 5
Start-VM -VM “$VMName“
Start-Sleep -Seconds 90
Invoke-VMScript -ScriptText “curl -o /root/apache.sh https://raw.githubusercontent.com/vmtocloud/apache_centos7/master/apache.sh” -vm “$VMName“ -GuestUser ”root” -GuestPassword 'VMware1!' -ScriptType bash
Start-Sleep -Seconds 5
Invoke-VMScript -ScriptText “chmod +x /root/apache.sh“ -vm “$VMName“ -GuestUser ”root” -GuestPassword 'VMware1!' -ScriptType bash
Start-Sleep -Seconds 5
Invoke-VMScript -ScriptText “echo sh /root/apache.sh | at now“ -vm “$VMName“ -GuestUser ”root” -GuestPassword 'VMware1!' -ScriptType bash
(Get-VMGuest -VM (Get-VM -name “$VMName“)).IPAddress
