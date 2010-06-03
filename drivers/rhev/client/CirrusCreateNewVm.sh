#!/bin/sh
# Author: jlabocki@redhat.com
# Date: 05.27.10
# Use: CirrusCreateNewVm.sh [configuration] [servicename]
# This script takes a csv file containing hostname,ip,mac (${vmlist}) and calls a remote script on
#    1. a RHEV Managment Server to create a new virtual machine
#

source ${1}
source ${libraries}
source ${driverdir}/rhev/conf/rhev.conf

servicename=${2}

#Find a single line to get things from
line=`grep -m 1 ${2} $vmlist`
	logline "$0:line is : ${line}"
	servicename=`echo ${line} |awk -F "," '{print $1}'`
	virtualmachine=`echo ${line} |awk -F "," '{print $2}'`
	virtualmachineprefix=`echo ${virtualmachine} |sed 's/[0-9]*//g' `
	ipaddress=`echo ${line} |awk -F "," '{print $3}'`
	macaddress=`echo ${line} |awk -F "," '{print $4}'`
	virt=`echo ${line} |awk -F"virt" '{print $2}' |awk -F"," '{print $1}'`
	drivera=`echo ${line} |awk -F "," '{print $5}' |awk -F ";" '{print $2}'`
	driverb=`echo ${line} |awk -F "," '{print $6}' |awk -F ";" '{print $2}'`
	driverc=`echo ${line} |awk -F "," '{print $7}' |awk -F ";" '{print $2}'`
	driverd=`echo ${line} |awk -F "," '{print $8}' |awk -F ";" '{print $2}'`
	logline "$0:virt is: ${virt}"


#Get a list of currently running virtual machines
CirrusListVm=`ssh -f ${username}@${rhevm} "${libpath}/CirrusListVm.bat"  |grep -i name |grep ${virtualmachineprefix} |awk -F":" '{print $2}' |sort |tail -1 | awk '{gsub(/^[ \t]+|[ \t]+$/,"")};1' |awk '{sub(/\r$/,"")};1'`
	
logline "$0: currently running virtual machine is: ${CirrusListVm}"

#If no virtual machines named mrgexec exist then start mrgexec01, otherwise get the last one.
if  [[ -z `echo ${CirrusListVm} |grep ${virtualmachineprefix}` ]]; then
	nextnode=${virtualmachineprefix}1
else 
        number=`echo ${CirrusListVm} |sed 's/[a-z][A-Z]*//g'`
        next=$((number+1))
        nextnode=${virtualmachineprefix}${next}
fi

logline "$0: next virtual machine is: ${nextnode}"

#Get new node details from gridlist file
line=`grep ${nextnode}, ${vmlist}`
        logline "$0:next virtual machine line is : ${line}"
        servicename=`echo ${line} |awk -F "," '{print $1}'`
        virtualmachine=`echo ${line} |awk -F "," '{print $2}'`
        virtualmachineprefix=`echo ${virtualmachine} |sed 's/[0-9]*//g' `
        ipaddress=`echo ${line} |awk -F "," '{print $3}'`
        macaddress=`echo ${line} |awk -F "," '{print $4}'`
	fqdn=${virtualmachine}.${domain}

#See if a templatemap exists for the service name, if so, use the template, if not, just PXE boot and let the systems management handle building the server.
line=`grep ${servicename} ${driverdir}/rhev/conf/templatemap |awk -F";" '{print $2}'`
logline "$0: line is : $line"
if [[ -z `echo ${line}` ]]; then
	#The default template in RHEV
	template="none"
else
	template=${line}
fi
logline "$0: using template: ${template}"

#Call script on RHEVM server via ssh to create a new virtual machine
#(Cirrus) --ssh--> (RHEVM(.bat-->.ps1))
if [[ $template != "none" ]]; then
	#Use template name ($1) and get template ID to pass to rhev api
	this=`ssh -f ${username}@${rhevm} "${libpath}/CirrusCreateNewVm.bat ${virtualmachine} ${ipaddress} ${macaddress} ${template}"`
	logline "ssh -f ${username}@${rhevm} \"${libpath}/CirrusCreateNewVm.bat ${virtualmachine} ${ipaddress} ${macaddress} ${template}\""
	logline "$0: Creating Virtual Machine using template"
else
	this=`ssh -f ${username}@${rhevm} "${libpath}/CirrusCreateNewVm.bat ${virtualmachine} ${ipaddress} ${macaddress} none"`
	logline "ssh -f ${username}@${rhevm} \"${libpath}/CirrusCreateNewVm.bat ${virtualmachine} ${ipaddress} ${macaddress} none\""
	logline "$0: Creating Virtual Machine without template"
fi

logline "$0:complete"
exit 0
