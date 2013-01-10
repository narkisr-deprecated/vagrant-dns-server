
module VagrantDns
  module Middleware
    class Update
	def initialize(app, env)
	  @app = app
	end

	def call(env)
	  @app.call(env)
	  update env[:vm] if env["vm"].state == :running
	end

	protected
	def update(vm)
        VagrantDns::NetworkBinder.new.bind(vm)
	end
    end
  end
end
