# -*- mode: ruby -*-
# vi: set ft=ruby :

conf = {
# Generic parameters used across all ONAP components
  'public_net_id'       => '00000000-0000-0000-0000-000000000000',
  'key_name'            => 'ecomp_key',
  'pub_key'             => '',
  'nexus_repo'          => 'https://nexus.onap.org/content/sites/raw',
  'nexus_docker_repo'   => 'nexus3.onap.org:10001',
  'nexus_username'      => 'docker',
  'nexus_password'      => 'docker',
  'dmaap_topic'         => 'AUTO',
  'artifacts_version'   => '1.0.0',
  'docker_version'      => '1.0-STAGING-latest',
  'gerrit_branch'       => 'release-1.0.0',
# Parameters for DCAE instantiation
  'dca_zone'            => 'iad4',
  'dcae_state'          => 'vi',
  'openstack_tenant_id' => '',
  'openstack_username'  => '',
  'openstack_api_key'   => '',
  'openstack_password'  => '',
  'nexus_repo_root'     => 'https://nexus.onap.org',
  'nexus_url_snapshot'  => 'https://nexus.onap.org/content/repositories/snapshots',
  'gitlab_branch'       => 'master'
}

vd_conf = ENV.fetch('VD_CONF', 'etc/settings.yaml')
if File.exist?(vd_conf)
  require 'yaml'
  user_conf = YAML.load_file(vd_conf)
  conf.update(user_conf)
end

Vagrant.configure("2") do |config|
  config.vm.box = 'sputnik13/trusty64'
  config.vm.synced_folder './opt', '/opt/', create: true

  config.vm.define :dns do |dns|
    dns.vm.hostname = 'dns'
    dns.vm.network :private_network, ip: '192.168.50.3'
    dns.vm.provider "virtualbox" do |v|
      v.customize ["modifyvm", :id, "--memory", 1 * 1024]
    end
    dns.vm.provision 'shell' do |s| 
      s.path = 'dns.sh'
      s.env = conf
    end 
  end

  config.vm.define :aai do |aai|
    aai.vm.hostname = 'aai'
    aai.vm.network :private_network, ip: '192.168.50.4'
    aai.vm.provider "virtualbox" do |v|
      v.customize ["modifyvm", :id, "--memory", 3 * 1024]
    end
    aai.vm.provision 'shell' do |s| 
      s.path = 'aai.sh'
      s.env = conf
    end 
    aai.vm.provider "libvirt" do |v|
      v.memory = 3 * 1024
      v.nested = true
    end
  end

  config.vm.define :mso do |mso|
    mso.vm.hostname = 'mso-server'
    mso.vm.network :private_network, ip: '192.168.50.5'
    mso.vm.provider "virtualbox" do |v|
      v.customize ["modifyvm", :id, "--memory", 4 * 1024]
    end
    mso.vm.provider "libvirt" do |v|
      v.memory = 4 * 1024
      v.nested = true
    end
    mso.vm.provision 'shell' do |s| 
      s.path = 'mso.sh'
      s.env = conf
    end 
  end

  config.vm.define :message_router do |message_router|
  end

  config.vm.define :robot do |robot|
  end

  config.vm.define :vid do |vid|
  end

  config.vm.define :sdnc do |sdnc|
  end

  config.vm.define :sdc do |sdc|
  end

  config.vm.define :portal do |portal|
  end

  config.vm.define :dcae_controller do |dcae_controller|
  end

  config.vm.define :policy do |policy|
  end

  config.vm.define :appc do |appc|
  end
end
