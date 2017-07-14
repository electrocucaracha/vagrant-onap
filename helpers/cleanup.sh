#!/bin/bash

vagrant destroy -f $1
rm -rf ../opt/
rm -rf ~/.m2/repository
vagrant up $1
