require 'vagrant_dns_plugin'

#see http://tinyurl.com/bfuawuj  
Vagrant.actions[:provision].insert_after(Vagrant::Action::VM::Provision, VagrantDns::Middleware::Update)
Vagrant.actions[:start].insert_after(Vagrant::Action::VM::Boot, VagrantDns::Middleware::Update)

Vagrant.actions[:destroy].insert_after(Vagrant::Action::VM::ProvisionerCleanup, VagrantDns::Middleware::Remove)

