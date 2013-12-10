require 'vagrant'
require 'zmq'
# client
require 'moneta'
require 'vagrant_dns/consts'
require 'vagrant_dns/configuration'
require 'vagrant_dns/port'
require 'vagrant_dns/middleware/update'
require 'vagrant_dns/middleware/remove'
require 'vagrant_dns/middleware/network_binder'

#see http://tinyurl.com/bfuawuj  
module VagrantDnsServer
  class Plugin < Vagrant.plugin("2")
    name 'vagrant-dns-server'
    description <<-DESC
    VagrantDnsServer
    DESC


    action_hook(:vagrant_dns_plugin) do |hook|
	# hook.after(::Vagrant::Action::Builtin::Provision, VagrantDns::Middleware::Update)
	hook.after(VagrantPlugins::ProviderVirtualBox::Action::Boot, VagrantDns::Middleware::Update)
    end

  end
end


