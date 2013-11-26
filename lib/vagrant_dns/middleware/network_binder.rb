
require 'zmq'

module VagrantDns

  UI = Vagrant::UI::Colored.new()
  class NetworkBinder
    def bind(vm)
	(host,ip) = host_ip(vm)
	Status.new.report(host,ip,:up)
    end		   

    def unbind(vm)
	(host,ip) = host_ip(vm)
	Status.new.report(host,ip,:down)
    end		   

    private 
    def host_ip(vm)
	network = vm.config.vm.networks.find do |type,network_parameters|
	  type == :private_network
	end
	ip = network[1][:ip]
	host = vm.config.vm.hostname
	[host, ip]
    end
  end

  class Status
    # if socket is created on middleware initialization vagrant will get stuck
    def report(host,ip,status)
	url = CONF.get('zmq_url')
	if(port_open?('localhost',url.split(':')[-1]))
	  context = ZMQ::Context.new
	  pub = context.socket(ZMQ::PUB)
	  pub.connect(url)
	  UI.say(:debug,"connection made")
	  pub.send("#{CHANNEL} #{host} #{ip} #{status.to_s}", ZMQ::NOBLOCK)
	  UI.say(:info,"notifying dns server with #{status} status")
	  pub.close
	else
	  UI.say(:debug,"dns server isn't up, skiping notifying #{status} status") 
	end
    end
  end
end
