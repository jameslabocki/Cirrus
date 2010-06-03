#!/bin/sh
# Author: jlabocki@redhat.com
# Date: 05.27.10
# Use: CirrusRemoveVm.sh [configuration] [servicename]
# This script takes a csv file containing hostname,ip,mac (${vmlist}) and calls a remote script on
#    1. A RHEVM server to remove a virtual machine
#

source ${1}
source ${libraries}
source ${driverdir}/satellite/conf/satellite.conf

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

#Get a list of vms
case $virt
in

	";rhev")
	source ${driverdir}/rhev/conf/rhev.conf
	CirrusListVm=`ssh -f ${username}@${rhevm} "${libpath}/CirrusListVm.bat"  |grep -i name |grep ${virtualmachineprefix} |awk -F":" '{print $2}' |sort |tail -1 | awk '{gsub(/^[ \t]+|[ \t]+$/,"")};1' |awk '{sub(/\r$/,"")};1'`
	;;

	*)
	logline "$0:no virt defined, cannot list current virtual machines"
	exit 1
	;;

esac
	
	logline "$0: currently running virtual machine is: ${CirrusListVm}"


#If no virtual machines named mrgexec exist then start mrgexec01, otherwise get the last one.
if  [[ -z `echo ${CirrusListVm} |grep ${virtualmachineprefix}` ]]; then
	nextnode=${virtualmachineprefix}1
else 
        number=`echo ${CirrusListVm} |sed 's/[a-z][A-Z]*//g'`
        nextnode=${virtualmachineprefix}${number}
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

#Remove system to Cobbler on Satellite
logline "$0:cobbler system remove --name=${virtualmachine}"
ssh -f ${satusername}@${satellite} "cobbler system remove --name=${virtualmachine}"

#Sync Cobbler
logline "$0:syncing cobbler"
ssh -f ${satusername}@${satellite} "cobbler sync" &> /dev/null

#Call Removal Perl Script

logline "$0:complete"
exit 0
