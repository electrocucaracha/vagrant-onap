#!/bin/bash

set -o xtrace

cd /opt
./common.sh

# Download scripts from Nexus
curl -k $nexus_repo/org.openecomp.demo/boot/$artifacts_version/mr_serv.sh -o /etc/init.d/mr_serv.sh
chmod +x /etc/init.d/mr_serv.sh
update-rc.d mr_serv.sh defaults

# Run docker-compose to spin up containers
if [ ! -d /opt/dcae/message-router ]; then
  git clone -b $gerrit_branch --single-branch http://gerrit.onap.org/r/dcae/demo/startup/message-router.git /opt/dcae/message-router 
fi
./mr_vm_init.sh
