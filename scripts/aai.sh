#!/bin/bash

set -o xtrace

source /var/onap/functions
source /var/onap/aai

configure_dns
create_configuration_files
install_dev_tools
install_java
install_maven
install_docker_engine
install_docker_compose

configure_service aai_serv.sh
init_aai
