# pub.rb
require 'zmq'

context = ZMQ::Context.new
chan    = ARGV[0]
user    = ARGV[1]
pub     = context.socket ZMQ::PUB
# pub.bind 'ipc:///tmp/2'
pub.connect 'tcp://127.0.0.1:5004'

while msg = STDIN.gets
  msg.strip!
  pub.send "#{chan} #{user} #{msg}"
end

