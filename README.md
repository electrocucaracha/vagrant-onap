# ONAP on Vagrant

[![Build Status](https://api.travis-ci.org/electrocucaracha/vagrant-onap.svg?branch=master)](https://api.travis-ci.org/electrocucaracha/vagrant-onap)

This vagrant project pretends to collect information about a way to deploy
and build [ONAP project](https://www.onap.org/) into a development environment.

### Problem Being Solved

* Reduce the barrier of entry to allow new ONAP developers to ramp up on to
active development quickly
* Reduce the cost to the community in responding to simple environment setup
questions faced by new developers

---

| Component        | Requirement                           |
|------------------|---------------------------------------|
| Vagrant          | >= 1.8.6                              |
| Hypervisor       | VirtualBox or Libvirt                 |
| Operating System | Linux, Mac OS or Windows(In Progress) |
| Hard Disk        | > 8 GB of free disk                   |
| Memory           | > 12 GB                               |

---

## Execution:

#### deploying a single application

    vagrant up <app_name>

current options include:

| app_name  | description                         |
|:---------:|-------------------------------------|
| aai       | Active and Available Inventory      |
| appc      | Application Controller              |
| dcae      | Data Collection Analytics & Events  |
| mr        | Message Router                      |
| mso       | Master Service Orchestrator         |
| policy    | Policy                              |
| portal    | Portal                              |
| robot     | Robot                               |
| sdc       | Service Design & Creation           |
| sdnc      | Software Defined Network Controller |
| vid       | Virtual Infrastructure Development  |
| vfc       | Virtual Function Controller (WIP)   |

#### setting up proxy in case you are behind a firewall

add http_proxy and https_proxy to your environment variables

Linux or Mac

    export http_proxy=<proxy>
    export https_proxy=<proxy>

Windows

    setx http_proxy <proxy> /M
    setx https_proxy <proxy> /M

##### choosing vagrant provider
force VirtualBox provider

    vagrant up --provider=virtualbox

setup the default provider on Windows

    setx VAGRANT_DEFAULT_PROVIDER=virtualbox /M

## Environment variables

| Variable     | Description                      |
|--------------|----------------------------------|
|`$http_proxy` | URL for corporate proxy          |
|`$https_proxy`| URL for corporate proxy          |
|`$no_proxy`   | Bypass URLs                      |
|`$DEPLOY_MODE`| all-in-one, individual or testing|

## Contributing

Bug reports and patches are most welcome.
See the [contribution guidelines](CONTRIBUTING.md).

## License

Apache-2.0
