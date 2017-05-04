#!/bin/bash

set -o xtrace

# configure_dns() - DNS/GW IP address configuration
function configure_dns {
    echo "nameserver 10.0.0.1" >> /etc/resolvconf/resolv.conf.d/head
    resolvconf -u
}

# create_configuration_files() -  Store credentials in files
function create_configuration_files {
    mkdir -p /opt/config
    echo $nexus_docker_repo > /opt/config/nexus_docker_repo.txt
    echo $nexus_username > /opt/config/nexus_username.txt
    echo $nexus_password > /opt/config/nexus_password.txt
    echo $openstack_username > /opt/config/openstack_username.txt
    echo $openstack_tenant_id > /opt/config/tenant_id.txt
    echo $dmaap_topic > /opt/config/dmaap_topic.txt
    echo $docker_version > /opt/config/docker_version.txt
}

# install_dev_tools() - Install basic dependencies
function install_dev_tools {
    apt-get update -y
    apt-get install -y \
        apt-transport-https \
        ca-certificates \
        curl \
        git
}

# install_bind9() - Install bind9 utils
function install_bind9 {
    apt-get update -y
    apt-get install -y bind9 bind9utils
}

# install_java8() - Install java8 binaries
function install_java8 {
    apt-get update -y
    apt-get install -y software-properties-common
    add-apt-repository -y ppa:openjdk-r/ppa
    apt-get update -y
    apt-get install -y openjdk-8-jdk
}

# install_maven3() - Install maven3 binaries
function install_maven3 {
    apt-get update -y
    apt-get install -y software-properties-common
    add-apt-repository -y ppa:andrei-pozolotin/maven3
    apt-get update -y
    apt-get install -y maven3 

    # Force Maven3 to use jdk8
    apt-get purge openjdk-7-jdk -y
}

# install_docker_engine() - Download and install docker-engine 
function install_docker_engine {
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    add-apt-repository \
        "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
        $(lsb_release -cs) \
        stable"
    apt-get update
    apt-get install -y docker-ce
    service docker start
}

# install_docker_engine() - Download and install docker-engine 
function install_docker_compose {
    local docker_compose_version=${1:-1.12.0}
    if [ ! -d /opt/docker ]; then
        mkdir /opt/docker
        curl -L https://github.com/docker/compose/releases/download/$docker_compose_version/docker-compose-`uname -s`-`uname -m` > /opt/docker/docker-compose
        chmod +x /opt/docker/docker-compose
    fi
}

# configure_service() - Download and configure a specific service in upstart
function configure_service {
    local service_script=$1
    curl -k $nexus_repo/org.openecomp.demo/boot/$artifacts_version/$service_script -o /etc/init.d/$service_script
    chmod +x /etc/init.d/$service_script
    update-rc.d $service_script defaults
}

