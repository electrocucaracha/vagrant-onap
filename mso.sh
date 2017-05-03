#!/bin/bash

set -o xtrace

cd /opt
./common.sh

# Download scripts from Nexus
curl -k $nexus_repo/org.openecomp.demo/boot/$artifacts_version/mso_serv.sh -o /etc/init.d/mso_serv.sh
chmod +x /etc/init.d/mso_serv.sh
update-rc.d mso_serv.sh defaults

# Run docker-compose to spin up containers
if [ ! -d /opt/mso/docker-config ]; then
  git clone -b $gerrit_branch --single-branch http://gerrit.onap.org/r/mso/docker-config.git /opt/mso/docker-config
fi
MSO_ENCRYPTION_KEY=$(cat /opt/mso/docker-config/encryption.key)
echo -n "$openstack_api_key" | openssl aes-128-ecb -e -K $MSO_ENCRYPTION_KEY -nosalt | xxd -c 256 -p > /opt/config/api_key.txt
./mso_vm_init.sh
