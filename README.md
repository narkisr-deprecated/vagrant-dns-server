# Intro
vagrant-dns enables easy dns management of multiple local Vagrant machines.

It composed from a Vagrant plugin and standalone dns server, the plugin auto registers the host and ip of the VM once it boots up making it available for lookup on both the host and guest machines.

Follow [this](https://www.youtube.com/watch?v=6GFobNDvwpI) this demo to see it in action.

# Install
 
```bash
$ sudo aptitude install libzmq1 libzmq-dev
$ vagrant plugin install vagrant-dns-server
# dns server
$ gem install vagrant_dns_server 

```

# Usage

DNS server side:
```bash
# generate configuration
$ rvmsudo vagrant_dns generate
$ cat ~/.vagrant_dns.yaml
--- 
 upstream_dns: 8.8.8.8
 zmq_url: tcp://127.0.0.1:7005

# change dns setting to point to localhost
$ cat /etc/resolv.conf
nameserver 127.0.0.1
search local
# Now start the local server
$ rvmsudo vagrant_dns server

I, [2013-12-10T20:42:45.764894 #6408]  INFO -- : Starting RubyDNS server (v0.6.0)...
I, [2013-12-10T20:42:45.765000 #6408]  INFO -- : Listening on tcp:localhost:53
I, [2013-12-10T20:42:45.765301 #6408]  INFO -- : Listening on udp:localhost:53
processing
```

Now you can launch vagrant instances and watch them get registered

```bash
# On the server stdout
[192.168.2.25->ubuntu-redis.local]: is up
```

Make sure to have local ip address on the vagrant machines:

```ruby
Vagrant.configure("2") do |config|

  config.vm.define :ubuntu do |ubuntu|
    ubuntu.vm.box = 'ubuntu-13.04_puppet-3.3.1'
    ubuntu.vm.hostname = 'ubuntu-redis.local'
    ubuntu.vm.network :forwarded_port, guest: 6379, host: 6379
    ubuntu.vm.network :private_network, ip: "192.168.2.25"
  end
end

```
# Developing
ts recommended to have RVM installed, currently ruby 1.9.3 is used (see .ruby files)

```bash 
$ git clone git://github.com/narkisr/vagrant-dns-server.git
$ gem install bundle
$ bundle install 
# start the server (generating default configuration first)
$ ./bin/vagrant_dns generate
$ rvmsudo ./bin/vagrant_dns server 
# run the plugin in development mode
$ bundle exec vagrant up 
```
# Alternatives

There are two existing project that aim to provide similar functionality:

 * BerlinVagran [vagrant-dns](https://github.com/BerlinVagrant/vagrant-dns) which seems to be able to manage only a single machine and is OSX only.
 
 * [vagrant-hostname](https://github.com/mosaicxm/vagrant-hostmaster) which manipulates /etc/hosts, this requires to enter sudo password for each machine (not an option when starting numerous machines).


# Copyright and license

Copyright [2013] [Ronen Narkis]

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

   [http://www.apache.org/licenses/LICENSE-2.0](http://www.apache.org/licenses/LICENSE-2.0) 

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

