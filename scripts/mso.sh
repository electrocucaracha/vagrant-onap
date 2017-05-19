#!/bin/bash

set -o xtrace

source /var/onap/functions
source /var/onap/mso

configure_dns
create_configuration_files
install_dev_tools
install_java

configure_service mso_serv.sh
init_mso
