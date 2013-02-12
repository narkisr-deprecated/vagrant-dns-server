
require 'zmq'

module VagrantDns

  UI = Vagrant::UI::Colored.new('dns')
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
	networks = vm.config.vm.networks.find_all do |type,network_parameters|
	  type == :hostonly 
	end
	ips = networks.map {|type,params| params.first}
	host = vm.config.vm.host_name
	[host,ips.first]
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
	  res = pub.send("#{CHANNEL} #{host} #{ip} #{status.to_s}", ZMQ::NOBLOCK)
	  UI.say(:info,"notifying dns server with #{status} status")
	  pub.close
	else
	  UI.say(:debug,"dns server isn't up, skiping notifying #{status} status") 
	end
    end
  end
end
