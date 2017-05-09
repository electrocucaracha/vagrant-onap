#!/bin/bash

set -o xtrace

source /var/onap/functions

install_dev_tools
install_java
install_bind
configure_bind
