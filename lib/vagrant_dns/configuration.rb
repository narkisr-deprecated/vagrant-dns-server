
CONF = VagrantDns::Configuration.new

module VagrantDns
  
  class Configuration
     extend Forwardable
    def_delegator :@store, :store, :get
    def_delegator :@store, :load, :set
    def_delegator :@store, :delete, :delete

    def initialize
      @store = Moneta.new(:YAML,:file => "#{ENV['home']}/.vagrant_dns.yaml")
    end
 	
  end

end
