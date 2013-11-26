require 'vagrant_dns_plugin'

#see http://tinyurl.com/bfuawuj  
class Plugin < Vagrant.plugin("2")
  name 'Vagrant DNS plugin'
  
  action_hook(:vagrant_dns_plugin) do |hook|
    hook.after(::Vagrant::Action::Builtin::Provision, VagrantDns::Middleware::Update)
    hook.after(VagrantPlugins::ProviderVirtualBox::Action::Boot, VagrantDns::Middleware::Update)
  end

  # Vagrant.actions[:provision].insert_after(Vagrant::Action::VM::Provision, )
  # Vagrant.actions[:start].insert_after(Vagrant::Action::VM::Boot, VagrantDns::Middleware::Update)
  # Vagrant.actions[:destroy].insert_after(Vagrant::Action::VM::ProvisionerCleanup, VagrantDns::Middleware::Remove)
end


