#!/bin/bash

set -o xtrace

source /var/onap/common.sh

configure_dns
create_configuration_files
install_dev_tools
install_java8
install_maven3
install_docker_engine
install_docker_compose

configure_service aai_serv.sh

mkdir -p /opt/openecomp/aai/logs
mkdir -p /opt/openecomp/aai/data

# Run docker-compose to spin up containers
bash /opt/aai_vm_init.sh
