module VagrantDns
  class NetworkBinder
    def bind(vm)
	networks = vm.config.vm.networks.find_all do |type,network_parameters|
	    type == :hostonly 
	end
      ips = networks.map {|type,params| params.first}
	host = vm.config.vm.host_name
	Status.new.up(host,ips.first)
    end		   
  end
  class Status
    # if socket is created on middleware initialization vagrant will get stuck
    def up(host,ip)
	context = ZMQ::Context.new
	pub = context.socket ZMQ::PUB
	puts "connecting to #{URL}"
	pub.connect URL
	pub.send "#{CHANNEL} #{host} #{ip} up"
	pub.close
    end
  end
end
