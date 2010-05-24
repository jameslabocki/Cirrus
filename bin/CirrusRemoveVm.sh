#!/bin/sh
# Author: jlabocki@redhat.com
# Date: 05.13.10
# Use: CirrusRemoveVm.sh
# This script takes a csv file containing hostname,ip,mac (${gridlist}) and calls a remote script on
#    1. rhev-m server (${rhevm}) to add a virtual machine with the proper mac address.
#    2. satellite server (${satellite}) to remove the system to cobbler so it receives the proper ip and mac address
#

#RHEVM Username
username=admin
#RHEVM Server
rhevm=ra-rhevm2-vm
#Satellite Server
satellite=ra-sat-vm
#Satellite User
satusername=root
#Path to RHEVM Scripting Library
libpath="/cygdrive/c/Program\ Files\ \(x86\)/RedHat/RHEVManager/RHEVM\ Scripting\ Library"
#Grid Node List
gridlist=/home/mrgmgr/GridNodeList
#domain
domain=ra.rh.com

#Get a list of vms
mrgexecvms=`ssh -f ${username}@${rhevm} "${libpath}/ciabListVm.bat"  |grep -i name |grep mrgexec |awk -F":" '{print $2}' |sort -r |tail -1 | awk '{gsub(/^[ \t]+|[ \t]+$/,"")};1' |awk '{sub(/\r$/,"")};1'`

#If no virtual machines named mrgexec exist then start mrgexec01, otherwise get the last one.
if  [[ -z `echo ${mrgexecvms} |grep mrgexec` ]]; then
	nextnode=mrgexec1
else 
        nextnode=`echo ${mrgexecvms} |cut -c 8-9`
        next=$((number+1))
        nextnode=mrgexec${next}
fi

#Get new node details from gridlist file
detail=`grep ${nextnode}, ${gridlist}`

#Split out csv values
nodeip=`echo ${detail} | awk -F"," '{print $2}'`
nodemac=`echo ${detail} | awk -F"," '{print $3}'`
nodename=`echo ${detail} | awk -F"," '{print $1}'`
fqdn=${nodename}.${domain}

#Add system to Cobbler on Satellite
ssh -f ${satusername}@${satellite} "cobbler system add --name=${nodename} --profile=coe-mrg-gridexec:22:tenants --mac=${nodemac} --ip=${nodeip} --hostname=${fqdn} --dns-name=${fqdn}"

#Sync Cobbler
ssh -f ${satusername}@${satellite} "cobbler sync"

#Call Script to Create virtual machine on rhevm (ra-rhevm2-vm)
if [ $1 ]; then
	#Use template name ($1) and get template ID to pass to rhev api
	echo "use template"
	#templateid=`ssh -f ${username}@${rhevm} "${libpath}/ciabListTemplates.bat $1" |grep -i TemplateId |awk -F" " '{print $3}'`
	echo "templateid:${templateid}"
	echo "nodename:${nodename}"
	echo "nodeip:${nodeip}"
	echo "nodemac:${nodemac}"
	echo "ssh -f ${username}@${rhevm} \"${libpath}/ciabCreateNewVm.bat ${nodename} ${nodeip} ${nodemac} ${1}\""
	echo ""
	this=`ssh -f ${username}@${rhevm} "${libpath}/ciabCreateNewVm.bat ${nodename} ${nodeip} ${nodemac} ${1}"`
	echo ""
	echo "Ran Create New Vm"
else
	echo "use satellite"
	ssh -f ${username}@${rhevm} "${libpath}/ciabCreateNewVm.bat ${nodename} ${nodeip} ${nodemac} none"
fi
