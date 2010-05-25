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

#Error Checking
if [ $# -lt 2 ]; then
	echo "./Cirrus.sh service add|remove|list [OPTIONS]"
	exit 1
fi

while [ $# -gt 0 ]
do
	case $1
	in
		-c)
		config=$2
		shift 2
		;;

		service)
		service=service
		shift 2
		;;

                add)
                add=add
                shift 2
                ;;

                remove)
                remove=remove
                shift 2
                ;;

                list)
                list=list
                shift 2
                ;;


    *)
	echo "The arguments to use are"
	echo "-c: configuration file"
	echo "add - Add a virtual machine to the service"
	echo "remove - Remove a virtual machine from the service"
	echo "list - List virtual machines in a service"
      shift 1
    ;;
  esac
done

# Source Configuration File if none specified
if [ -z $config ]; then
	config=/usr/local/Cirrus/Cirrus/conf/Cirrus.conf
fi

#
echo "using $config"
