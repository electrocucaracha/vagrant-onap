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

configure_service mso_serv.sh


# Run docker-compose to spin up containers
if [ ! -d /opt/mso/docker-config ]; then
  git clone -b $gerrit_branch --single-branch http://gerrit.onap.org/r/mso/docker-config.git /opt/mso/docker-config
fi
MSO_ENCRYPTION_KEY=$(cat /opt/mso/docker-config/encryption.key)
echo -n "$openstack_api_key" | openssl aes-128-ecb -e -K $MSO_ENCRYPTION_KEY -nosalt | xxd -c 256 -p > /opt/config/api_key.txt
bash /opt/mso_vm_init.sh
