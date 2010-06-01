#!/bin/sh
# Author: jlabocki@redhat.com
# Date: 05.27.10
# Use: CirrusCreateNewVm.sh [config] [Template]
#
# [Template] - The ID of the template to use in RHEV. This bypasses the use of Satellite to provision the virtual machine and uses a RHEV template. This would be a great place to leverage deltacloud to be virtualization agnostic.

source ${1}
source ${driverdir}/rhev/conf/rhev.conf

#echo ${bindir}

