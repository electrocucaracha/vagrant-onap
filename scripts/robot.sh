#!/bin/bash

set -o xtrace

source /var/onap/functions
source /var/onap/robot

configure_dns
create_configuration_files
install_dev_tools
install_java

configure_service robot_vm_init.sh
init_robot
