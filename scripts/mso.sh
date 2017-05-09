#!/bin/bash

set -o xtrace

source /var/onap/functions
source /var/onap/mso

configure_dns
create_configuration_files
install_dev_tools
install_java
install_maven
install_docker_engine
install_docker_compose

configure_service mso_serv.sh
init_mso
