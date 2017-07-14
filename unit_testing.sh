#!/bin/bash

set -o xtrace

rm -rf /opt/
rm -rf /root/.m2/

set -o errexit

for file in $( ls /var/onap_tests/*); do
    bash ${file}
done
