#!/bin/bash

set -o xtrace

source /var/onap/functions
source /var/onap/sdc

configure_dns
create_configuration_files
install_dev_tools
install_java

configure_service asdc_serv.sh
init_sdc
