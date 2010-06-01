#!/bin/sh
# Author: jlabocki@redhat.com
# Date: 05.27.10
# Use: CirrusCreateNewVm.sh [config] [Template]
#
# [Template] - The ID of the template to use in RHEV. This bypasses the use of Satellite to provision the virtual machine and uses a RHEV template. This would be a great place to leverage deltacloud to be virtualization agnostic.

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



