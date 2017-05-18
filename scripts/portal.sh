#!/bin/bash

set -o xtrace

source /var/onap/functions
source /var/onap/portal

configure_dns
create_configuration_files
install_dev_tools
install_java
install_docker_engine
install_docker_compose

configure_service portal_serv.sh
init_portal
