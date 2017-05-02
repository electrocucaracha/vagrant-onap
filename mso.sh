#!/bin/bash

set -o xtrace

# DNS/GW IP address configuration
echo "nameserver 10.0.0.1" >> /etc/resolvconf/resolv.conf.d/head
resolvconf -u

# Download dependencies
add-apt-repository -y ppa:openjdk-r/ppa
apt-get update -y
apt-get install -y \
  apt-transport-https \
  ca-certificates \
  curl \
  software-properties-common \
  openjdk-8-jdk \
  git \ 
  ntp \
  ntpdate

# Download scripts from Nexus
curl -k $nexus_repo/org.openecomp.demo/boot/$artifacts_version/mso_vm_init.sh -o /opt/mso_vm_init.sh
curl -k $nexus_repo/org.openecomp.demo/boot/$artifacts_version/mso_serv.sh -o /opt/mso_serv.sh
chmod +x /opt/mso_vm_init.sh
chmod +x /opt/mso_serv.sh
mv /opt/mso_serv.sh /etc/init.d
update-rc.d mso_serv.sh defaults

#Download and install docker-engine and docker-compose
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
apt-get update
apt-get install -y docker-ce
service docker start

mkdir /opt/docker
curl -L https://github.com/docker/compose/releases/download/1.9.0/docker-compose-`uname -s`-`uname -m` > /opt/docker/docker-compose
chmod +x /opt/docker/docker-compose

# Store credentials in files
mkdir -p /opt/config
echo "$nexus_docker_repo" > /opt/config/nexus_docker_repo.txt
echo "$nexus_username" > /opt/config/nexus_username.txt
echo "$nexus_password" > /opt/config/nexus_password.txt
echo "$openstack_username" > /opt/config/openstack_username.txt
echo "$openstack_tenant_id" > /opt/config/tenant_id.txt
echo "$dmaap_topic" > /opt/config/dmaap_topic.txt
echo "$docker_version" > /opt/config/docker_version.txt

# Run docker-compose to spin up containers
cd /opt
git clone -b $gerrit_branch --single-branch http://gerrit.onap.org/r/mso/docker-config.git test_lab
MSO_ENCRYPTION_KEY=$(cat /opt/test_lab/encryption.key)
echo -n "$openstack_api_key" | openssl aes-128-ecb -e -K $MSO_ENCRYPTION_KEY -nosalt | xxd -c 256 -p > /opt/config/api_key.txt

./mso_vm_init.sh
