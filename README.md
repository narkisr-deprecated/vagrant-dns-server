# Intro
vagrant-dns enables easy dns management of multiple local Vagrant machines.

It composed from a Vagrant plugin and standalone dns server, the plugin auto registers the host and ip of the VM once it boots up making it available for lookup on both the host and guest machines.

Follow [this](https://www.youtube.com/watch?v=6GFobNDvwpI) this demo to see it in action.

# Install
 
```bash
  $ sudo aptitude install libzmq1  libzmq-dev
  $ gem install vagrant-dns-server
```

# Usage

Add the plugin to the project Gemfile, use vagrant_dns server to boot the local dns server


# Alternatives

There are two existing project that aim to provide similar functionality:

 * BerlinVagran [vagrant-dns](https://github.com/BerlinVagrant/vagrant-dns) which seems to be able to manage only a single machine and is OSX only.
 
 * [vagrant-hostname](https://github.com/mosaicxm/vagrant-hostmaster) which manipulates /etc/hosts, this requires to enter sudo password for each machine (not an option when starting numerous machines).


# Copyright and license

Copyright [2013] [Ronen Narkis]

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

