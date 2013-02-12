require 'socket'
require 'timeout'

# see http://stackoverflow.com/questions/517219/ruby-see-if-a-port-is-open
def port_open?(ip, port, seconds=1)
  Timeout::timeout(seconds) do
    begin
	TCPSocket.new(ip, port).close
	true
    rescue Errno::ECONNREFUSED, Errno::EHOSTUNREACH
	false
    end
  end
rescue Timeout::Error
  false
end
