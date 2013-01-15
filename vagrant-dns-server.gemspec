# -*- encoding: utf-8 -*-
require File.expand_path('../lib/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Ronen Narkis"]
  gem.email         = ["narkisr@gmail.com"]
  gem.description   = %q{A vagrant plugin to automanage dns registration on local machine}
  gem.summary       = %q{A vagrant plugin that sets up a local dns server}
  gem.homepage      = "https://github.com/narkisr/vagrant-dns"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "vagrant-dns-server"
  gem.require_paths = ["lib"]
  gem.version       = VagrantDns::VERSION

  gem.add_dependency  'vagrant', '~>1.0.3'
  gem.add_dependency  'rubydns'
  gem.add_dependency  'em-zeromq'
  gem.add_dependency  'thor'
  gem.add_dependency  'rubydns'
  gem.add_development_dependency  'bundler'
  gem.add_development_dependency  'mocha', '~>0.12.3'
  gem.add_development_dependency  'rake'
  gem.add_development_dependency  'minitest'

end
