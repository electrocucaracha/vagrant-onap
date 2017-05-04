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

configure_service mr_serv.sh

# Run docker-compose to spin up containers
if [ ! -d /opt/dcae/message-router ]; then
  git clone -b $gerrit_branch --single-branch http://gerrit.onap.org/r/dcae/demo/startup/message-router.git /opt/dcae/message-router 
fi
bash /opt/mr_vm_init.sh
