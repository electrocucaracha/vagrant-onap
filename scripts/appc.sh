#!/bin/bash

set -o xtrace

source /var/onap/functions
source /var/onap/appc

configure_dns
create_configuration_files
install_dev_tools
install_java

configure_service appc_serv.sh
init_appc
