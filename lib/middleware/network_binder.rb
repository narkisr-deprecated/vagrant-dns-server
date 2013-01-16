module VagrantDns

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
	context = ZMQ::Context.new
	pub = context.socket ZMQ::PUB
	puts "connecting to #{URL}"
	pub.connect URL
	pub.send "#{CHANNEL} #{host} #{ip} #{status.to_s}"
	pub.close
    end
  end
end
