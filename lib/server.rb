require 'em-zeromq'
require 'constants'
require 'resolver'
require 'dns'
require 'eventmachine'

module VagrantDns
  class Server
    def initialize
	traps
	@resolv = VagrantDns::ResolvConf.new
    end


    def unpack(message)
	_, host, ip, msg = message.split ' ', 4
	[host, ip, msg.to_sym]
    end

    def process
	begin
	  # @resolv.append
	  zmq = EM::ZeroMQ::Context.new(1)
	  EM.run {
	    @dns = VagrantDns::DnsServer.new
	    puts "processing "
	    pull= zmq.socket(ZMQ::SUB)
	    pull.bind(URL)
	    pull.subscribe 'vagrant'
	    pull.on(:message) { |part|
            host, ip, stat=  unpack(part.copy_out_string)
		puts "[#{ip}->#{host}]: is #{stat.to_s}"
		REG.register(host,ip) if :up.eql?(stat)
		REG.delete(host) if :down.eql?(stat)
		part.close
	    }
	  }
	rescue => e
	  $stderr.puts e
	  $stderr.puts e.backtrace.join("\n")
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
	# @resolv.clear
	EM::stop()
    end
  end
end
