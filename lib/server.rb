# require 'zmq'
require 'em-zeromq'
require 'constants'
require 'dns'
require 'eventmachine'

module VagrantDns
  class Server
    def initialize
    end

    def process
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
    end

    def shutdown
	$stderr.puts "Cleaning up server"
	@sub.close
	EM::stop()
    end
  end
end
