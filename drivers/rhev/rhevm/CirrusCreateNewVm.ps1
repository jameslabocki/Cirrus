#Remove this section once the default cmdlet problem is fixed in this environment
######
#$configDirectory = "C:\Program Files (x86)\RedHat\RHEVManager\RHEVM Scripting Library\"
#$currAppDomain = [System.AppDomain]::CurrentDomain
#$currAppDomain.SetData("APP_CONFIG_FILE",$configDirectory  + "RHEVMCmd.dll.config") 
#Add-PSSnapin RHEVMPSSnapin
#$global:ps = get-command -pssnapin RHEVMPSSnapin
######

#Script to create a new virtual machine named first command line argument (newname)

$nodename = $args[0]
$nodeip = $args[1]
$nodemac = $args[2]
$template = $args[3]

#$nodename = "mrgexec1"
#$nodemac = "00:1A:4A:14:80:BB"

#Login
Login-User admin 100yard- WORKGROUP

#Set blank template
$t = get-template 00000000-0000-0000-0000-000000000000

#Create New VM, if no template is provided then use blank and use Satellite/PXE, if a template is given use the specified template
if ( $template -match "none" ) {

	echo "Using Satellite"
	add-vm -TemplateObject $t -Name $nodename -MemorySize 512 -Os RHEL5 -NumOfCpus 1 -HostClusterId 1 
	Start-Sleep -s 4
	$vm = Select-Vm ("name=$nodename")
	$vmid = $vm.VmId
	
	#Add Disk
	$d = New-Disk -DiskSize 20 -DiskType System -DiskInterface VirtIO -Volumetype Preallocated
	
	Start-Sleep -s 4
	
	Add-Disk -DiskObject $d -VmObject $vm
	
	#Add Network Interface
	$a = Select-Vm ("Name=$nodename")
	add-NetworkAdapter -VmObject $a -InterfaceName eth0 -MacAddress $nodemac -NetworkName rhevm
	
	Start-Sleep -s 4
	
	#Start Vm
	Start-Vm -VmId $vmid -BootDevice cn -DisplayType VNC

} else {

	echo "Using Template"


	#Select Template
	$templateid = Select-Template ("name=$template")


	add-vm -TemplateObject $templateid -Name $nodename -HostClusterId 1 
	Start-Sleep -s 4

	#NOT NEEDED IF THE INTERFACE IS DELETED FROM TEMPLATE
	#Delete the network interface and add a new one. 
	#We need to do this because the MAC has to be registered in cobbler for the dhcp lease
	#to be correctly provided to the virtual machine
	$a = Select-Vm ("Name=$nodename")
	
	#Remove NetworkAdapter
	#$iface = $a.GetNetworkAdapters() | ? { $_.name -eq 'eth0' }
	#Remove-NetworkAdapter -VmObject $a -NetworkAdapter $iface

	# Add new interface
	add-NetworkAdapter -VmObject $a -InterfaceName eth0 -MacAddress $nodemac -NetworkName rhevm
	
	$vm = Select-Vm ("name=$nodename")
	$vmid = $vm.VmId
	
	Start-Sleep -s 4
	
	#Start Vm
	Start-Vm -VmId $vmid -DisplayType VNC

}