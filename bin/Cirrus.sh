#!/bin/bash
# This is the master script that calls scripts located in ./driver based on the configuration files found in ./conf/CirrusVmList
# 
# ./Cirrus.sh service add|remove|list [OPTIONS]
# 
# Cirrus.sh adds, removes, or lists the virtual machines running in a cloud that match a particular service name as defined in the CirrusVmList file.
#
# service - the name of the service as defined in ./conf/CirrusVmList
#
# add - Add a virtual machine to the service
# remove - Remove a virtual machine from the service
# list - List virtual machines in a service

# Error Checking
if [ $# -lt 2 ]; then
	echo "./Cirrus.sh service add|remove|list [OPTIONS]"
fi

# Source Configuration File
/usr/local/cirrus/conf/Cirrus.conf


#
