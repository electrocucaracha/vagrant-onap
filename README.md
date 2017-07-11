# Vagrant ONAP

[![Build Status](https://api.travis-ci.org/electrocucaracha/vagrant-onap.svg?branch=master)](https://api.travis-ci.org/electrocucaracha/vagrant-onap)

This vagrant project pretends to collect information about a way to deploy [ONAP project](https://www.onap.org/) into a development environment.  It was created only for didactic purposes.

## Requirements:

* Vagrant
* VirtualBox or Libvirt

## Supported OS
* Linux 
* MAC OS
* Windows is in testing 


## Steps for execution:

    git clone https://github.com/electrocucaracha/vagrant-onap.git
    cd vagrant-onap
    vagrant up

## Destroy:

    vagrant destroy

## Options:
##### deploying a single application
    vagrant up <application name>
current options include:
>aai
>appc
>asserts
>commons
>dcea
>mr
>mso
>policy
>portal
>robot
>sdc
>sdnc
>vid

##### setting up proxy in case you are behind a fire wall

add http_proxy and https_proxy to your environment variables

Linux or Mac

    export http_proxy=<proxy>
    export https_proxy=<proxy>

Windows

    setx http_proxy <proxy> /M
    setx https_proxy <proxy> /M

##### choosing vagrant provider
in Windows on first exaction run 

    vagrant up --provider=virtualbox
to use virtual box as the default provider
the commend needs to be executed once

