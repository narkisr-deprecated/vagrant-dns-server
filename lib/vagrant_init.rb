require 'vagrant'
require 'constants'
require 'middleware/update'
require 'middleware/network_binder'
require 'zmq'

Vagrant.actions[:provision].insert_after(Vagrant::Action::VM::Provision, VagrantDns::Middleware::Update)
Vagrant.actions[:start].insert_after(Vagrant::Action::VM::Provision, VagrantDns::Middleware::Update)

