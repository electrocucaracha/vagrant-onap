#!/bin/bash

set -o xtrace

source /var/onap/functions

create_configuration_files
install_dev_tools
install_java
configure_bind

for serv in sdc aai mso mr robot vid sdnc portal dcae; do
    source /var/onap/${serv}
    configure_service ${serv}_serv.sh
    init_${serv}
done
