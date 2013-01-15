require 'em-zeromq'
require 'constants'
require 'resolver'
require 'dns'
require 'eventmachine'

module VagrantDns
  class Server
    def initialize
	traps
	VagrantDns::ResolvConf.new.append
    end

    def process
	begin
	  zmq = EM::ZeroMQ::Context.new(1)
	  EM.run {
	    @dns = VagrantDns::DnsServer.new
	    puts "processing "
	    pull= zmq.socket(ZMQ::SUB)
	    pull.bind(URL)
	    pull.subscribe 'vagrant'
	    pull.on(:message) { |part|
		chan, host, ip, msg = part.copy_out_string.split ' ', 4
		puts "#{chan} [#{ip}->#{host}]: is #{msg}"
		REG.register(host,ip)
		part.close
	    }
	  }
	rescue 
	  shutdown
	end
    end

    def traps 
	%w(INT SIGINT TERM).each{|s|
	  Signal.trap(s) {shutdown}
	}
    end

    def shutdown
	$stderr.puts "Cleaning up server"
	EM::stop()
    end
  end
end
