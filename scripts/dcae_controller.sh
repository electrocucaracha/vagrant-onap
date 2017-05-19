#!/bin/bash

set -o xtrace

source /var/onap/functions
source /var/onap/dcae

configure_dns
create_configuration_files
install_dev_tools
install_java

configure_service dcae_serv.sh
init_dcae
