# CirrusCreateNewVm.ps1
# Creates a New Virtual Machine in RHEV-M

#Script to create a new virtual machine named first command line argument (newname)

#Get Command Line Arguments
# 0 - Name for the VM
# 1 - IP Address for the VM
# 2 - MAC Address for the VM
# 3 - Template to be used to create (if plank, then PXE booted)
$nodename = $args[0]
$nodeip = $args[1]
$nodemac = $args[2]
$template = $args[3]

#Log into RHEV API
#Login-User username password domain

#Set blank template
$t = get-template 00000000-0000-0000-0000-000000000000

#Create New VM, if no template is provided then use blank and use Satellite/PXE, if a template is given use the specified template
if ( $template -match "none" ) {

	add-vm -TemplateObject $t -Name $nodename -MemorySize 512 -Os RHEL5 -NumOfCpus 1 -HostClusterId 1 
	Start-Sleep -s 4
	$vm = Select-Vm ("name=$nodename")
	$vmid = $vm.VmId
	
	#Add Disk
	$d = New-Disk -DiskSize 20 -DiskType System -DiskInterface VirtIO -Volumetype Preallocated
	
	Add-Disk -DiskObject $d -VmObject $vm
	
	#Add Network Interface
	$a = Select-Vm ("Name=$nodename")
	add-NetworkAdapter -VmObject $a -InterfaceName eth0 -MacAddress $nodemac -NetworkName rhevm
	
	#Start Vm
	Start-Vm -VmId $vmid -BootDevice cn -DisplayType VNC

} else {

	#Select Template
	$templateid = Select-Template ("name=$template")


	add-vm -TemplateObject $templateid -Name $nodename -HostClusterId 1 
	Start-Sleep -s 4

	$a = Select-Vm ("Name=$nodename")
	
	#Remove NetworkAdapter
        #NOT NEEDED IF THE INTERFACE IS DELETED FROM TEMPLATE
        #Delete the network interface and add a new one. 
        #We need to do this because the MAC has to be registered in cobbler for the dhcp lease
        #to be correctly provided to the virtual machine
	#$iface = $a.GetNetworkAdapters() | ? { $_.name -eq 'eth0' }
	#Remove-NetworkAdapter -VmObject $a -NetworkAdapter $iface

	# Add new interface
	add-NetworkAdapter -VmObject $a -InterfaceName eth0 -MacAddress $nodemac -NetworkName rhevm
	
	$vm = Select-Vm ("name=$nodename")
	$vmid = $vm.VmId
	
	#Start Vm
	Start-Vm -VmId $vmid -DisplayType VNC

}
