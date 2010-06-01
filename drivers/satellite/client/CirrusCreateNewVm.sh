#!/bin/sh
# Author: jlabocki@redhat.com
# Date: 05.27.10
# Use: CirrusCreateNewVm.sh [configuration] [Template]
# This script takes a csv file containing hostname,ip,mac (${gridlist}) and calls a remote script on
#    1. satellite server (${satellite}) to add the system to cobbler so it receives the proper ip and mac address
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

#See if a profilemap exists for the service name, if so, use it, if not, use the service name for profile
line=`grep ${servicename} ${driverdir}/satellite/conf/profilemap |awk -F";" '{print $2}'`
logline "$0: line is : $line"
if [[ -z `echo ${line}` ]]; then
	profile=${servicename}
else
	profile=${line}
fi
logline "$0: using profile: ${profile}"

#Add system to Cobbler on Satellite
logline "$0:cobbler system add --name=${virtualmachine} --profile=${profile} --mac=${macaddress} --ip=${ipaddress} --hostname=${fqdn} --dns-name=${fqdn}"
ssh -f ${satusername}@${satellite} "cobbler system add --name=${virtualmachine} --profile=${profile} --mac=${macaddress} --ip=${ipaddress} --hostname=${fqdn} --dns-name=${fqdn}"

#Sync Cobbler
logline "$0:syncing cobbler"
ssh -f ${satusername}@${satellite} "cobbler sync" &> /dev/null

logline "$0:complete"
exit 0
