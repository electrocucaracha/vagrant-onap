#!/bin/bash

set -o xtrace

source /var/onap/functions
source /var/onap/policy

configure_dns
create_configuration_files
install_dev_tools
install_java

configure_service policy_serv.sh
init_policy
