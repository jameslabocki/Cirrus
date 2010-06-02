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
if [ $# -lt 3 ]; then
	echo "./Cirrus.sh -s service add|remove|list [OPTIONS]"
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

		-s)
		service=$2
		shift 2
		;;

                add)
                action=$1
                shift 1
                ;;

                remove)
                action=$1
                shift 1
                ;;

                list)
               	action=$1
                shift 1
                ;;


		*)
		echo "The arguments to use are:"
		echo "-c: configuration file"
		echo "-s: service"
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

source ${config}
source ${libraries}

logline "Starting Cirrus.sh"

case $action
in
	add)
	addvm $service
	;;

	remove)
	echo "remove"
	removevm $service
	;;

	list)
	echo "list"
	;;

	*)
	echo "No action specified"
	exit 1
	;;
esac

