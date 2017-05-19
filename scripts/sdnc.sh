#!/bin/bash

set -o xtrace

source /var/onap/functions
source /var/onap/sdnc

configure_dns
create_configuration_files
install_dev_tools
install_java

configure_service sdnc_serv.sh
init_sdnc
