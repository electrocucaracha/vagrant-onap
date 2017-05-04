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

configure_service robot_vm_init.sh

mkdir /opt/eteshare/config 

# Run docker-compose to spin up containers
if [ ! -d /opt/testsuite/properties ]; then
  git clone -b $gerrit_branch --single-branch http://gerrit.onap.org/r/testsuite/properties.git /opt/testsuite/properties
fi
bash /opt/robot_vm_init.sh
