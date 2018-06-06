#!/bin/bash

if [[ "$debug" == "True" ]]; then
    set -o xtrace
fi

source /var/onap/functions

if [[ $no_proxy && $no_proxy != *$IP_ADDRESS* ]]; then
    export no_proxy=$no_proxy,$IP_ADDRESS
fi
if [[ $NO_PROXY && $NO_PROXY != *$IP_ADDRESS* ]]; then
    export NO_PROXY=$NO_PROXY,$IP_ADDRESS
fi

update_repos
create_configuration_files
configure_bind

for serv in $@; do
    source /var/onap/${serv}
    configure_service ${serv}
    init_${serv}
    echo "source /var/onap/${serv}" >> ~/.bashrc
done

echo "source /var/onap/functions" >> ~/.bashrc
