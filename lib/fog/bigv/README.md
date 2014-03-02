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

### Valid attributes

These are the attributes you can set when creating (or updating) servers:

- **name** (required - must be unique in the account)
- **root_password** - root password for the new server (required - only for creation)
- **cores** - number of CPU cores
- **memory** (in megabytes)
- **autoreboot_on** - whether the VM should be restarted on power down
- **power_on** - whether the VM should be powered on
- **cdrom_url** - URL of a .iso file to use as a CDROM drive for custom installs
- **hardware_profile**
- **initial_discs** (optional array, only for creation - see example below)


### How many?

```ruby
>> bigv.servers.count
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
    management_address="213.xxx.xxx.xxx",
    cdrom_url=nil,
    head="head01",
    hardware_profile="virtio2013",
    hardware_profile_locked=false
  >
```

Or you can do the same using the name:

```ruby
>> server = bigv.servers.get('myserver-name')
  <Fog::Compute::BigV::Server
    id=12610,
    group_id=1,
    name="myserver-name",
    hostname="myserver-name.default.myaccountname.uk0.bigv.io",
    cores=1,
    memory=1024,
    autoreboot_on=true,
    power_on=true,
    management_address="213.xxx.xxx.xxx",
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
?>                               :root_password => 'new_root_password')
  <Fog::Compute::BigV::Server
    id=12610,
    group_id=1,
    name="myserver-name",
    hostname="myserver-name.default.myaccountname.uk0.bigv.io",
    cores=1,
    memory=1024,
    autoreboot_on=true,
    power_on=false,
    management_address="213.xxx.xxx.xxx",
    cdrom_url=nil,
    head=nil,
    hardware_profile="virtio2013",
    hardware_profile_locked=false
  >
```

#### Intialize first and create on save

```ruby
server = bigv.servers.new(:name => 'myserver_name')
server.root_password = 'new_root_password'
server.save
```

#### Custom Specification

```ruby
server = bigv.servers.create(:name => 'my-bigger-server-name',
                             :root_password => 'new_root_password',
                             :cores => 2,
                             :memory => 2048,
                             :initial_discs => [ {:label => 'vda', :storage_grade => 'sata', :size => 10240} ])
```


### IP Addresses

```ruby
>> server.public_ip_address
"213.xxx.xxx.xxx"

>> server.public_ip_address
"213.xxx.xxx.xxx"

>> server.ipv4_address
"213.xxx.xxx.xxx"

>> server.ipv6_address
"2001:ffff:ff:fff:ffff:ff:ffff:ffff"

>> server.ip_addresses
[""213.xxx.xxx.xxx"", "2001:ffff:ff:fff:ffff:ff:ffff:ffff"]

>> server.ipv4_addresses
["213.xxx.xxx.xxx"]

>> server.ipv6_addresses
["2001:ffff:ff:fff:ffff:ff:ffff:ffff"]

```

### Start

```ruby
>> server.start
true
```

### Stop

```ruby
>> server.stop
true
```

### Restart

```ruby
>> server.restart
true
```

### wait_for

wait_for blocks until the condition in the block is complete - great for after server creation!

```ruby
>>  server = bigv.servers.create(:name => 'myserver-name',
?>                               :root_password => 'new_root_password')
  <Fog::Compute::BigV::Server
    id=12610,
    group_id=1,
    name="myserver-name",
    hostname="myserver-name.default.myaccountname.uk0.bigv.io",
    cores=1,
    memory=1024,
    autoreboot_on=true,
    power_on=false,
    management_address="213.xxx.xxx.xxx",
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

### SSH

```ruby
>> server.ssh('uptime', :password => 'new_root_password')
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
    management_address="213.xxx.xxx.xxx",
    cdrom_url=nil,
    head="head23",
    hardware_profile="virtio2013",
    hardware_profile_locked=false
  >
```

Note that this will turn the server back on when you save as the server variable still has power_on = true and autoreboot_on = true still set.

If that is not intended, you need to do: server.reload after doing the save action.


### Delete

```ruby
>> server.destroy
true
```

Deleted servers are taken down, but are still around but with the deleted attribute set to true. This means they will not show in "bigv.servers" listings any more, but can be accessed using "bigv.servers.get()" in the same way as before it was deleted.

Deleted servers can be manipulated as a collection with:

```ruby
>> bigv.servers.deleted
...
```

This works in exactly the same, array-like fashion as .servers does.


#### Undelete

Servers can be undeleted by setting the deleted flag back to false, or using:

```ruby
>> server.undelete
true
```

..assuming you still have the server variable around! - if not:

```ruby
>> bigv.servers.get(12345).undelete
true
```


### Purge

If you would like to purge a deleted server, or even delete an active server but ensure it can't be undeleted, you can use the purge method:

```ruby
>> server.purge
true
```

This will not show in "bigv.servers" and will be completely removed, the IP address returned to the pool and the name re-usable.

If you would like to purge all of your deleted servers, you can use:

```ruby
>> bigv.servers.purge_all
true
```

### Re-image

If you wuold like to re-image (re-install) the virtual machine, you can use the reimage method. This takes distribution and a root_password parameters like when creating a VM. This can only be performed on a Virtual Machine in the off state. Once complete, the machine will be in a powered on state, but with it's autoreboot_on attribute set to false.

```ruby
>> server.stop
true
>> server.reimage(:distribution => 'precise', :root_password => 'new_root_password_here')
true
```

Once the re-image is complete, it will be left in an on state, so you can use wait_for again:

```ruby
>> server.wait_for { sshable?(:password => 'new_root_password_here') }
{:duration=>122.0}
```


### Discs

You can get the discs on the virtual machine by using:

```ruby
>> server.discs
  <Fog::Compute::BigV::Discs
    [
      <Fog::Compute::BigV::Disc
        id=13068,
        server_id=12726,
        label="vda",
        size=20480,
        storage_pool="tail04-sata2",
        storage_grade="sata"
      >
    ]
  >
```

This, like servers acts like an array:

```ruby
>> server.discs.count
1

>> server.discs?
true

>> server.discs.first
  <Fog::Compute::BigV::Disc
    id=13068,
    server_id=12726,
    label="vda",
    size=20480,
    storage_pool="tail04-sata2",
    storage_grade="sata"
  >
```

Note that this is cached on the first call, but you can force it to re-retrieve it from BigV:

```ruby
>> server.discs.reload
  <Fog::Compute::BigV::Discs
    [
      <Fog::Compute::BigV::Disc
        id=13068,
        server_id=12726,
        label="vda",
        size=20480,
        storage_pool="tail04-sata2",
        storage_grade="sata"
      >
    ]
  >
```


### Nics (network interfaces)

You can get the nics on the virtual machine by using:

```ruby
>> server.nics
  <Fog::Compute::BigV::Nics
    [
      <Fog::Compute::BigV::Nic
        id=12728,
        server_id=12726,
        label=nil,
        ips=["213.xxx.xxx.xxx", "2001:ffff:ff:fff:ffff:ff:ffff:ffff"],
        vlan_num=750,
        mac="fe:ff:00:00:ff:ff",
        extra_ips={}
      >
    ]
  >
```

This, like servers acts like an array:

```ruby
>> server.nics.count
1

>> server.nics?
true

>> server.nics.first
  <Fog::Compute::BigV::Nic
    id=12728,
    server_id=12726,
    label=nil,
    ips=["213.xxx.xxx.xxx", "2001:ffff:ff:fff:ffff:ff:ffff:ffff"],
    vlan_num=750,
    mac="fe:ff:00:00:ff:ff",
    extra_ips={}
  >
```

IP Addresses:

```ruby
>> server.nics.first.ip_addresses
["213.xxx.xxx.xxx", "2001:ffff:ff:fff:ffff:ff:ffff:ffff"]

>> server.nics.first.ipv4_addresses
["213.xxx.xxx.xxx"]

>> server.nics.first.ipv6_addresses
["2001:ffff:ff:fff:ffff:ff:ffff:ffff"]
```

Note that nics are cached on the first call, but you can force it to re-retrieve it from BigV:

```ruby
>> server.nics.reload
  <Fog::Compute::BigV::Nics
    [
      <Fog::Compute::BigV::Nic
        id=12728,
        server_id=12726,
        label=nil,
        ips=["213.xxx.xxx.xxx", "2001:ffff:ff:fff:ffff:ff:ffff:ffff"],
        vlan_num=750,
        mac="fe:ff:00:00:ff:ff",
        extra_ips={}
      >
    ]
  >
```

Get the primary interface (again, this is cached on the first call so will need reload to refresh):

```ruby
>> server.nics.primary
  <Fog::Compute::BigV::Nic
    id=12728,
    server_id=12726,
    label=nil,
    ips=["213.xxx.xxx.xxx", "2001:ffff:ff:fff:ffff:ff:ffff:ffff"],
    vlan_num=750,
    mac="fe:ff:00:00:ff:ff",
    extra_ips={}
  >
```


### Iteration

Now we can programatically control servers, we can do things like create and control multiple machines in one go. This could be very useful for bringing up a bunch of new web servers to increase capacity for instance!

Below is a little script I whipped up to test out creating five servers at once. It first loops round and sets them all off creating. It then waits for each one to become available and prints it's details. It then waits for each to be sucessfullly ssh'd in to and purges them (so the resources are freed back up).

Obviously use this with caution if you don't want to get landed with a big bill!

Here is the code:

```ruby
NUM_OF_SERVERS=5
PASSWD = 'YOUR_PASSWORD_HERE'

bigv = Fog::Compute.new({
  :provider => 'BigV',
  :bigv_account  => 'ACCOUNT_NAME_HERE',
  :bigv_username => 'USERNAME_HERE',
  :bigv_password => 'PASSWORD_HERE'
})

(1..NUM_OF_SERVERS).each do |s|
  puts "Creating server #{s}"
  bigv.servers.create(:name => "fog-test-#{s}", :password => PASSWD)
end

(1..NUM_OF_SERVERS).each do |s|
  puts "Waiting for server #{s} to come up"
  server = bigv.servers.get("fog-test-#{s}")
  puts server.wait_for { ready? }
  puts "#{server.id} - #{server.public_ip_address}"
end

(1..NUM_OF_SERVERS).each do |s|
  puts "Waiting for server #{s} to be accessible"
  server = bigv.servers.get("fog-test-#{s}")
  puts server.wait_for { sshable?(:password => PASSWD) }
  server.purge   # can not be undeleted!
end
```

and here is the output from that:

```
Creating server 1
Creating server 2
Creating server 3
Creating server 4
Creating server 5
Waiting for server 1 to come up
{:duration=>55.0}
12717 - 213.138.xxx.xxx
Waiting for server 2 to come up
{:duration=>4.0}
12718 - 213.138.xxx.xxx
Waiting for server 3 to come up
{:duration=>6.0}
12719 - 213.138.xxx.xxx
Waiting for server 4 to come up
{:duration=>6.0}
12720 - 213.138.xxx.xxx
Waiting for server 5 to come up
{:duration=>3.0}
12721 - 213.138.xxx.xxx
Waiting for server 1 to be accessible
{:duration=>168.0}
Waiting for server 2 to be accessible
{:duration=>10.0}
Waiting for server 3 to be accessible
{:duration=>0}
Waiting for server 4 to be accessible
{:duration=>0}
Waiting for server 5 to be accessible
{:duration=>0}
```

## Groups

### How many?

```ruby
>> bigv.groups.count
1
```

### Names?

```ruby
>> bigv.groups.map(&:name)
["default"]
```

### ID's and Names?

```ruby
>> bigv.groups.map { |s| { s.id => s.name} }
[{1=>"default"}]
```

### All

```ruby
>> bigv.groups
  <Fog::Compute::BigV::Groups
    [
      <Fog::Compute::BigV::Group
        id=1,
        name="default"
      >
    ]
  >
```

### Use like an Array

```ruby
>> bigv.groups[0]
      <Fog::Compute::BigV::Group
        id=1,
        name="default"
      >
>> bigv.groups.first
      <Fog::Compute::BigV::Group
        id=1,
        name="default"
      >

```

### Single by ID:

```ruby
  >> b.groups.get(1)
      <Fog::Compute::BigV::Group
        id=1,
        name="default"
      >
```

### Single by Name:

```ruby
>> b.groups.get('default')
      <Fog::Compute::BigV::Group
        id=1,
        name="default"
      >
```


### Create

```ruby
>> bigv.groups.map(&:name)
["default"]

>> bigv.groups.create(:name => 'test1')
  <Fog::Compute::BigV::Group
    id=6165,
    name="test1"
  >

>> group = bigv.groups.new(:name => 'test2')
  <Fog::Compute::BigV::Group
    id=nil,
    name="test2"
  >

>> bigv.groups.map(&:name)
["default", "test1"]

>> group.save
  <Fog::Compute::BigV::Group
    id=6166,
    name="test2"
  >

>> bigv.groups.map(&:name)
["default", "test1", "test2"]

>> group = bigv.groups.new
  <Fog::Compute::BigV::Group
    id=nil,
    name=nil
  >

>> group.name = 'test3'
"test3"

>> group.save
  <Fog::Compute::BigV::Group
    id=6167,
    name="test3"
  >

>> bigv.groups.map(&:name)
["default", "test1", "test2", "test3"]
```

### Update

```ruby
>> group = bigv.groups.get('test3')
  <Fog::Compute::BigV::Group
    id=6167,
    name="test3"
  >

>> group.name = 'test3-changed'
"test3-changed"

>> group.save
  <Fog::Compute::BigV::Group
    id=6167,
    name="test3-changed"
  >

>> bigv.groups.map(&:name)
["default", "test1", "test2", "test3-changed"]
```

### Delete

```ruby
>> group.destroy
true

>> bigv.groups.map(&:name)
["default", "test1", "test2"]
```

### Servers in Group

```ruby
>> bigv.servers.count
6

>> bigv.groups.first
  <Fog::Compute::BigV::Group
    id=306,
    name="default"
  >

>> bigv.groups.first.servers.count
6

>> bigv.groups.last
  <Fog::Compute::BigV::Group
    id=6168,
    name="test3"
  >

>> bigv.groups.last.servers.count
0

>> bigv.groups.last.servers.create(:name => 'fog-group3-test1', :password => 'password_here')
  <Fog::Compute::BigV::Server
    id=12742,
    group_id=6168,
    name="fog-group3-test1",
    hostname="fog-group3-test1.test3.ichilton.uk0.bigv.io",
    cores=1,
    memory=1024,
    autoreboot_on=true,
    power_on=false,
    management_address="213.138.104.213",
    cdrom_url=nil,
    head=nil,
    hardware_profile="virtio2013",
    hardware_profile_locked=false,
    deleted=false
  >

>> bigv.groups.last.servers.count
1

>> bigv.servers.count
7

>> bigv.groups.last.servers
  <Fog::Compute::BigV::Servers
    [
      <Fog::Compute::BigV::Server
        id=12742,
        group_id=6168,
        name="fog-group3-test1",
        hostname="fog-group3-test1.test3.myaccountname.uk0.bigv.io",
        cores=1,
        memory=1024,
        autoreboot_on=true,
        power_on=true,
        management_address="213.xxx.xxx.xxx",
        cdrom_url=nil,
        head="head22",
        hardware_profile="virtio2013",
        hardware_profile_locked=false,
        deleted=false
      >
    ]
  >
```
