require 'fileutils'
require 'tempfile'

RESOLV = '/etc/resolv.conf'
LOCAL = "nameserver 127.0.0.1\n"

class Module
  def redefine_const(name, value)
    __send__(:remove_const, name) if const_defined?(name)
    const_set(name, value)
  end
end

def atomic_write(path, content)
  temp_path = Tempfile.new(path)
  File.open(temp_path, 'w+') do |f|
    f.write(content)
  end
  FileUtils.mv(temp_path, path)
end

module VagrantDns
  class ResolvConf
    def append()
	input =  IO.readlines(RESOLV)
	ns_pos = input.find_index do |line|
	  line.include?('nameserver')
	end

	if(!local_defined?(input,ns_pos))
	  head = (input.slice(0,ns_pos) << LOCAL)
	  tail = input.slice(ns_pos,input.size)
	  newconf = head.concat(tail).join('')
	  atomic_write(RESOLV,newconf)
	end
    end

    def clear
	input = IO.readlines(RESOLV)
	cleaned = input.select{|line| !line.eql?(LOCAL)}.join('')
      atomic_write(RESOLV,cleaned)
    end

    def local_defined?(input,pos)
	input[pos].eql?(LOCAL.chomp)
    end
  end
end

