#!/bin/bash

set -o xtrace

# Download dependencies
add-apt-repository -y ppa:openjdk-r/ppa
apt-get update
apt-get install -y apt-transport-https ca-certificates wget openjdk-8-jdk bind9 bind9utils bind9-doc ntp ntpdate

# Download script
mkdir /etc/bind/zones

curl -k $nexus_repo/org.openecomp.demo/boot/$artifacts_version/db_simpledemo_openecomp_org -o /etc/bind/zones/db.simpledemo.openecomp.org
curl -k $nexus_repo/org.openecomp.demo/boot/$artifacts_version/named.conf.options -o /etc/bind/named.conf.options
curl -k $nexus_repo/org.openecomp.demo/boot/$artifacts_version/named.conf.local -o /etc/bind/named.conf.local

# Configure Bind
modprobe ip_gre
sed -i "s/OPTIONS=.*/OPTIONS=\"-4 -u bind\"/g" /etc/default/bind9
service bind9 restart
