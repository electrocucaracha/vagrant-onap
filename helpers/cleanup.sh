#!/bin/bash

case $1 in
    "all_in_one" )
        export DEPLOY_MODE='all-in-one' ;;
    "dns" | "mr" | "sdc" | "aai" | "mso" | "robot" | "vid" | "sdnc" | "portal" | "dcae" | "policy" | "appc" )
        export DEPLOY_MODE='individual' ;;
    "testing" )
        export DEPLOY_MODE='testing' ;;
esac

vagrant destroy -f $1
rm -rf ../opt/
rm -rf ~/.m2/repository
vagrant up $1
