require 'rubydns'
require 'moneta'
require 'forwardable'

UDNS = CONF.get('upstream_dns')
UPSTREAM = RubyDNS::Resolver.new([[:tcp, UDNS, 53], [:udp, UDNS, 53]])

module VagrantDns

  class Registry 
    extend Forwardable
    def_delegator :@store, :store, :register
    def_delegator :@store, :load, :read
    def_delegator :@store, :delete, :delete

    def initialize
      @store = Moneta.new(:YAML,:file => "hosts.yaml")
    end
  end

  class DnsServer
    def initialize
	RubyDNS::run_server(:listen => [[:tcp, "localhost", 53],[:udp, "localhost", 53]]) do
	  on(:start) do 
	    if ARGV.include?("--debug")
		@logger.level = Logger::DEBUG
	    else
		@logger.level = Logger::WARN
	    end

	  end

	  otherwise do |transaction|
	    ip = REG.read(transaction.name)
	    if(ip)
		transaction.respond!(ip)
	    else
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
