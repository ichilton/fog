# Bytemark BigV

This is a Fog compute provider for Bytemark BigV service.

- [http://www.bigv.io](http://www.bigv.io)
- [http://www.bytemark.co.uk](http://www.bytemark.co.uk)


Developed/maintained on behalf of Bytemark by:

  - Ian Chilton
  - **Email:**   ian@ichilton.co.uk
  - **Web:**     [http://www.ichilton.co.uk](http://www.ichilton.co.uk)
  - **Github:**  [http://github.com/ichilton](http://github.com/ichilton)
  - **Twitter:** @ichilton

API Documentation: [http://bigv-api-docs.ichilton.co.uk](http://bigv-api-docs.ichilton.co.uk)


## Status

This provider is currently under development and is work in progress.

The servers functionality is working and functional.

Control of discs & nics (embedded under servers) is in progress.

There are currently no mocks or tests for this provider - those are coming soon.

Use at your own risk - remember that usage of this provider could incur charges on your BigV account and could make modifications to any virtual machines etc you have in your BigV account.


## Installation - Pre-release 

Until the provider is included in the official fog release, it can be used as follows:

### Manual

    git clone https://github.com/ichilton/fog.git
    cd fog
    git checkout bigv_provider

From there, you can either run:

    bin/fog

or:

    require './lib/fog'    # in irb or a ruby file.


### Bundler

If you are using Bundler, you can add the following to your Gemfile and run 'bundle install':

    gem 'fog', :github => 'ichilton/fog', :branch => 'bigv_provider'



## Installation - Final

Once the provider is included in the official fog release, you'll use it as follows:

### Bundler

Add the following to your Gemfile and run 'bundle install':

    gem 'fog'


### Manual

    gem install fog

Unless you are using Rails, you need to require fog in both your ruby file(s) or in irb:

    require 'fog'



## Initialization

### Ruby files or irb:

```ruby
bigv = Fog::Compute.new({
  :provider => 'BigV',
  :bigv_account   => 'your_account_here',
  :bigv_username  => 'your_username_here',
  :bigv_password  => 'your_password_here'
})
```

If your account requires a Yubikey, you'll also need to supply the output from the Yubikey in the bigv_yubikey parameter:

    :bigv_yubikey  => 'push_yubikey_button_here'

You can also optionally specify :bigv_api_url, although this defaults to: https://uk0.bigv.io


### fog binary

If you use the fog binary (bin/fog), you can create a .fog file in your home directory which contains the following:

```ruby
:default:
  :bigv_account:    your_account_here
  :bigv_username:   your_username_here
  :bigv_password:   your_password_here
```

You can then just do the following instead of the Fog::Compute.new code above:

    bigv = Compute[:bigv]

Great for quick testing, as you can very quickly do:

```ruby
$ bin/fog 
  Welcome to fog interactive!
  :default provides BigV, Openvz and Vmfusion

>> Compute[:bigv].servers.count
4
>>
```

## Servers

To maintain compatibility with other Fog providers, virtual machines in BigV terminology are called servers in Fog. 

### How many?

```ruby
?> bigv.servers.count
4
```

### Names?

````ruby
>> bigv.servers.map(&:name)
["myserver1", "myserver2", "myserver3", "myserver4"]
````

### ID's and Names?

```ruby
>> bigv.servers.map { |s| { s.id => s.name} }
[{1=>"myserver1"}, {2=>"myserver2"}, {3=>"myserver3"}, {4=>"myserver4"}]
```

### Use like an Array

```ruby
bigv.servers.first
bigv.servers.last
bigv.servers[0]
```

### All servers

    bigv.servers

### Single server by ID:

```ruby
>> server = bigv.servers.get(12610)
  <Fog::Compute::BigV::Server
    id=12610,
    group_id=1,
    name="myserver-name",
    hostname="myserver-name.default.myaccountname.uk0.bigv.io",
    cores=1,
    memory=1024,
    autoreboot_on=true,
    power_on=true,
    management_address="213.123.123.123",
    cdrom_url=nil,
    head="head01",
    hardware_profile="virtio2013",
    hardware_profile_locked=false
  >
```

### Create new virtual machine

#### Default Options (1 core, 1GB RAM, 20GB SATA Disc)

```ruby
>>  server = bigv.servers.create(:name => 'myserver-name',
?>                               :password => 'new_root_password')
  <Fog::Compute::BigV::Server
    id=12610,
    group_id=1,
    name="myserver-name",
    hostname="myserver-name.default.myaccountname.uk0.bigv.io",
    cores=1,
    memory=1024,
    autoreboot_on=true,
    power_on=false,
    management_address="213.123.123.123",
    cdrom_url=nil,
    head=nil,
    hardware_profile="virtio2013",
    hardware_profile_locked=false
  >
```

#### Intialize first and create on save

    server = bigv.servers.new(:name => 'myserver_name')
    server.password = 'new_root_password'
    server.save

#### Custom Specification

    server = bigv.servers.create(:name => 'my-bigger-server-name',
                                 :password => 'new_root_password',
                                 :cores => 2,
                                 :memory => 2048,
                                 :initial_discs => [ {:label => 'vda', :storage_grade => 'sata', :size => 10240} ])


#### IP Addresses

```ruby
>> server.public_ip_address
"213.123.123.123"

>> server.ipv4_address
"213.123.132.123"

>> server.ipv6_address
"2001:41c8:ff:ff:ffff:ff:ffff:ffff"
```

#### Start

```ruby
>> server.start
true
```

#### Stop

```ruby
>> server.stop
true
```

#### Reboot

```ruby
>> server.reboot
true
```

#### wait_for

wait_for blocks until the condition in the block is complete - great for after server creation!

```ruby
>>  server = bigv.servers.create(:name => 'myserver-name',
?>                               :password => 'new_root_password')
  <Fog::Compute::BigV::Server
    id=12610,
    group_id=1,
    name="myserver-name",
    hostname="myserver-name.default.myaccountname.uk0.bigv.io",
    cores=1,
    memory=1024,
    autoreboot_on=true,
    power_on=false,
    management_address="213.123.123.123",
    cdrom_url=nil,
    head=nil,
    hardware_profile="virtio2013",
    hardware_profile_locked=false
  >

>> server.wait_for { ready? }
{:duration=>94.0}

>> server.wait_for { sshable?(:password => 'new_root_password') }
{:duration=>122.0}

```

#### SSH

```ruby
?> server.ssh('uptime', :password => 'new_root_password')
[#<Fog::SSH::Result:0x007f9d4642ae10 @command="uptime", @stderr="", @stdout=" 15:06:09 up 4 min,  1 user,  load average: 0.08, 0.04, 0.03\r\n", @status=0>]
```

#### Update Existing Server

Only available on servers which are turned off.

```ruby
>> server.stop
true

>> server.name = 'myserver-name-changed'
"myserver-name-changed"

>> server.save
  <Fog::Compute::BigV::Server
    id=12610,
    group_id=1,
    name="myserver-name-changed",
    hostname="myserver-name-changed.default.myaccountname.uk0.bigv.io",
    cores=1,
    memory=1024,
    autoreboot_on=true,
    power_on=true,
    management_address="213.123.123.123",
    cdrom_url=nil,
    head="head23",
    hardware_profile="virtio2013",
    hardware_profile_locked=false
  >
```


#### Delete

```ruby
?> server.destroy
true
```
