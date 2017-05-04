#!/bin/bash

set -o xtrace

cd /opt
./common.sh

# Download scripts from Nexus
curl -k $nexus_repo/org.openecomp.demo/boot/$artifacts_version/robot_vm_init.sh -o /etc/init.d/robot_vm_init.sh
chmod +x /etc/init.d/robot_vm_init.sh
update-rc.d robot_vm_init.sh defaults

# Run docker-compose to spin up containers
if [ ! -d /opt/dcae/testsuite/properties ]; then
  git clone -b $gerrit_branch --single-branch http://gerrit.onap.org/r/testsuite/properties.git /opt/dcae/testsuite/properties
fi
./robot_vm_init.sh
