#!/bin/bash

set -o xtrace

cd /opt
./common.sh

# Download scripts from Nexus
curl -k $nexus_repo/org.openecomp.demo/boot/$artifacts_version/aai_serv.sh -o /etc/init.d/aai_serv.sh
chmod +x /etc/init.d/aai_serv.sh
update-rc.d aai_serv.sh defaults

mkdir -p /opt/openecomp/aai/logs
mkdir -p /opt/openecomp/aai/data

# Run docker-compose to spin up containers
./aai_vm_init.sh
