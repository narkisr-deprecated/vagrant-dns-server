require 'vagrant'
require 'log4r'
require 'constants'
require 'middleware/update'
require 'middleware/remove'
require 'middleware/network_binder'
require 'zmq'

#see http://tinyurl.com/bfuawuj  
Vagrant.actions[:provision].insert_after(Vagrant::Action::VM::Provision, VagrantDns::Middleware::Update)
Vagrant.actions[:start].insert_after(Vagrant::Action::VM::Provision, VagrantDns::Middleware::Update)

# Vagrant.actions[:destroy].insert_after(Vagrant::Action::VM::ProvisionerCleanup, VagrantDns::Middleware::Remove)
Vagrant.actions[:halt].insert_after(Vagrant::Action::VM::Halt, VagrantDns::Middleware::Remove)

