# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'vagrant_dns_server'

Vagrant.configure("2") do |config|

  config.vm.define :ubuntu do |ubuntu|
    ubuntu.vm.box = 'ubuntu-13.04_puppet-3.3.1' 
    ubuntu.vm.network :public_network, :bridge => 'eth0'
    ubuntu.vm.hostname = 'ubuntu.local'
    ubuntu.vm.network :forwarded_port, guest: 6379, host: 6379
    ubuntu.vm.network :private_network, ip: "192.168.2.25"

    ubuntu.vm.provider :virtualbox do |vb|
	vb.customize ['modifyvm', :id, '--memory', 2048, '--cpus', 2]
    end

  end

end
