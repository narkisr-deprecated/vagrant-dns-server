require 'rubydns'

IN = Resolv::DNS::Resource::IN
UPSTREAM = RubyDNS::Resolver.new([[:tcp, "8.8.8.8", 53], [:udp, "8.8.8.8", 53]])

module VagrantDns

  class Registry 
    def initialize
	@reg = {}
    end
    def register(host,ip)
	@reg[host] = ip	
    end

    def unregister(host)
	@reg[host] = nil
    end

    def read(host)
     @reg[host]	
    end
  end

  class DnsServer
    def initialize
	RubyDNS::run_server(:listen => [[:tcp, "localhost", 53],[:udp, "localhost", 53]]) do
	  otherwise do |transaction|
	    ip = REG.read(transaction.name)
	    if(ip)
		transaction.respond!(ip)
	    else
		puts "not found moving to UPSTREAM"
		begin
		  transaction.passthrough!(UPSTREAM)
		rescue Exception => e
		  puts e
		end
	    end
	  end
	end
    end
  end
end

REG = VagrantDns::Registry.new
