#!/bin/sh
# Author: jlabocki@redhat.com
# Date: 05.27.10
# Use: CirrusCreateNewVm.sh [configuration] [Template]
# This script takes a csv file containing hostname,ip,mac (${gridlist}) and calls a remote script on
#    1. satellite server (${satellite}) to add the system to cobbler so it receives the proper ip and mac address
#

source ${1}
source ${driverdir}/satellite/conf/satellite.conf

echo ${bindir}
