#!/bin/bash

NEXUS_USERNAME=$(cat /opt/config/nexus_username.txt)
NEXUS_PASSWD=$(cat /opt/config/nexus_password.txt)
NEXUS_DOCKER_REPO=$(cat /opt/config/nexus_docker_repo.txt)
DMAAP_TOPIC=$(cat /opt/config/dmaap_topic.txt)
DOCKER_IMAGE_VERSION=$(cat /opt/config/docker_version.txt)

# Pull HBase container from a public docker hub
docker login -u $NEXUS_USERNAME -p $NEXUS_PASSWD $NEXUS_DOCKER_REPO
docker pull $NEXUS_DOCKER_REPO/aaidocker/aai-hbase-1.2.3
docker rm -f hbase-1.2.3
docker run -d --net=host --name="hbase-1.2.3" aaidocker/aai-hbase-1.2.3

# Wait 3 minutes before instantiating the A&AI container
sleep 180

if [ -d /opt/aai/src/aai-service ]; then
  git clone https://git.onap.org/aai/aai-service /opt/aai/src/aai-service
fi
pushd /opt/aai/src/aai-service
mvn -N -P runAjsc
popd

docker pull $NEXUS_DOCKER_REPO/openecomp/ajsc-aai:$DOCKER_IMAGE_VERSION
docker rm -f aai-service
docker run --name=aai-service --net=host -v /etc/ssl/certs/ca-certificates.crt:/etc/ssl/certs/ca-certificates.crt -it -e AAI_REPO_PATH=r/aai -e AAI_CHEF_ENV=simpledemo -d -e AAI_CHEF_LOC=/var/chef/aai-data/environments -e docker_gitbranch=master $NEXUS_DOCKER_REPO/openecomp/ajsc-aai:$DOCKER_IMAGE_VERSION

if [ ! -d /opt/common/src/logging-service ]; then
  git clone https://git.onap.org/aai/logging-service /opt/common/src/logging-service
fi
pushd /opt/common/src/logging-service
mvn install
popd

if [ ! -d /opt/sdc/src/sdc-distribution-client ]; then
  git clone https://git.onap.org/sdc/sdc-distribution-client /opt/sdc/src/sdc-distribution-client
fi
pushd /opt/sdc/src/sdc-distribution-client
mvn install 
popd 

if [ ! -d /opt/aai/src/model-loader ]; then
  git clone https://git.onap.org/aai/model-loader /opt/aai/src/model-loader
fi
pushd /opt/aai/src/model-loader
cp /opt/files/model-loader.pom.xml ./pom.xml
mvn clean package docker:build
cat <<EOL > /etc/model-loader.conf
DISTR_CLIENT_ASDC_ADDRESS=${SDC_ADDRESS:-localhost}
DISTR_CLIENT_CONSUMER_GROUP=${UEB_CONSUMER_GROUP:-SDCGroup}
DISTR_CLIENT_CONSUMER_ID=${UEB_CONSUMER_GROUP_ID:-UEB}
DISTR_CLIENT_ENVIRONMENT_NAME=${ENVIRONMENT_NAME:-Env}
DISTR_CLIENT_PASSWORD=${SDC_PASSWORD:-password}
DISTR_CLIENT_USER=${SDC_USER:-SDCUser}
		     
APP_SERVER_BASE_URL=${APP_SERVER_URL:-https://localhost:8443}
APP_SERVER_AUTH_USER=${APP_USER:-AppUser}
APP_SERVER_AUTH_PASSWORD=${APP_PASSWORD:-password}
EOL
docker run --env-file /etc/model-loader.conf model-loader
popd
