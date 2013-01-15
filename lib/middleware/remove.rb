
module VagrantDns
  module Middleware
    class Remove
	def initialize(app, env)
	  @app = app
	end

	def call(env)
	  @app.call(env)
	  remove env[:vm] if env["vm"].created?
	end

	protected
	def remove(vm)
        VagrantDns::NetworkBinder.new.bind(vm)
	end
    end
  end
end
