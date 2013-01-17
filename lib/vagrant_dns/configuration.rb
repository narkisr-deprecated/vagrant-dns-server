

module VagrantDns
  
  class Configuration
     extend Forwardable
    def_delegator :@store, :store, :set
    def_delegator :@store, :load, :get
    def_delegator :@store, :delete, :delete

    def initialize
      @store = Moneta.new(:YAML,:file => "#{ENV['HOME']}/.vagrant_dns.yaml")
    end
 	
  end

end

CONF = VagrantDns::Configuration.new
