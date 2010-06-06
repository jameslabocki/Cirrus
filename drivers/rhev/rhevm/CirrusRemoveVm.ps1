#Shutdown a VM and then Remove it

#Get Command Line Argument
param([string] $p1)

#Login
#Login-User username password domain 
Login-User admin 100yard- WORKGROUP

#Hard Shutdown
$a = Select-Vm ("Name=$p1")
Shutdown-Vm -VmId $a.VmId

Shutdown-Vm -VmId $a.VmId

Remove-Vm $a




