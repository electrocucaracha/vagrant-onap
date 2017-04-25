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

cd /opt/src

git clone https://git.onap.org/aai/aai-service
pushd aai-service
mvn -N -P runAjsc
popd

docker pull $NEXUS_DOCKER_REPO/openecomp/ajsc-aai:$DOCKER_IMAGE_VERSION
docker rm -f aai-service
docker run --name=aai-service --net=host -v /etc/ssl/certs/ca-certificates.crt:/etc/ssl/certs/ca-certificates.crt -it -e AAI_REPO_PATH=r/aai -e AAI_CHEF_ENV=simpledemo -d -e AAI_CHEF_LOC=/var/chef/aai-data/environments -e docker_gitbranch=master $NEXUS_DOCKER_REPO/openecomp/ajsc-aai:$DOCKER_IMAGE_VERSION

git clone https://git.onap.org/aai/logging-service
pushd logging-service
mvn install
popd

git clone https://git.onap.org/sdc/sdc-distribution-client
pushd sdc-distribution-client
mvn install 
popd 

git clone https://git.onap.org/aai/model-loader
pushd model-loader
mvn clean package docker:build
cat <<EOL > /etc/model-loader.conf
DISTR_CLIENT_ASDC_ADDRESS=<SDC_ADDRESS>
DISTR_CLIENT_CONSUMER_GROUP=<UEB_CONSUMER_GROUP>  ;;  Uniquely identiy this group of model loaders.
DISTR_CLIENT_CONSUMER_ID=<UEB_CONSUMER_GROUP_ID>  ;;  Uniquely identiythis model loader.
DISTR_CLIENT_ENVIRONMENT_NAME=<ENVIRONMENT_NAME>  ;;  Environment name configured on the SDC
DISTR_CLIENT_PASSWORD=<DISTR_PASSWORD>            ;;  Password to connect to SDC
DISTR_CLIENT_USER=<USER_ID>                       ;;  User name to connect to SDC
		     
APP_SERVER_BASE_URL=https://<aai-address>:8443    ;; AAI Address (URL)
APP_SERVER_AUTH_USER=<USER_ID>                    ;; User name to connect to AAI
APP_SERVER_AUTH_PASSWORD=<PASSWORD>               ;; Password to connect to AAi
EOL
sudo docker run --env-file /etc/model-loader.conf model-loader /opt/jetty/jetty*/bin/startup.sh
popd
