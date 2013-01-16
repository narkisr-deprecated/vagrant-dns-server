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
	Thread.new {
	  context = ZMQ::Context.new
	  pub = context.socket(ZMQ::PUB)
	  pub.connect URL
	  UI.say(:debug,"connection made")
	  res = pub.send("#{CHANNEL} #{host} #{ip} #{status.to_s}", ZMQ::NOBLOCK)
	  UI.say(:info,"notifying dns server with #{status} status") if res
	  UI.say(:info,"dns server isn't up, skiping notifying #{status} status") if not res
	  pub.close
	}.join
    end
  end
end
