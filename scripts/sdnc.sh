#!/bin/bash

set -o xtrace

source /var/onap/common.sh

configure_dns
create_configuration_files
install_dev_tools
install_java8
install_docker_engine
install_docker_compose

configure_service sdnc_serv.sh

# Run docker-compose to spin up containers
if [ ! -d /opt/sdnc ]; then
  git clone -b $gerrit_branch --single-branch http://gerrit.onap.org/r/sdnc/oam.git /opt/sdnc
fi
bash /opt/sdnc_vm_init.sh
