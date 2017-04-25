#!/bin/bash

pushd opt/aai-service
mvn clean install -DskipTests
popd
