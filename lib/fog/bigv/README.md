# Bytemark BigV

This is a Fog compute provider for Bytemark BigV service.

- [http://www.bigv.io](http://www.bigv.io)
- [http://www.bytemark.co.uk](http://www.bytemark.co.uk)


Developed/maintained at Bytemark by:

  - Ian Chilton <ian.chilton [at] bytemark.co.uk>

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

```ruby
bigv.servers
```

### Single server by ID

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


### Create a new server

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

This will power on the machine and will set the autoreboot_on flag to true so the VM will automatically be re-started on power off.

```ruby
>> server.start
true
```

### Stop

This will power off the machine and will set the autoreboot_on flag to false so the VM will not be automatically be re-started and will stay in a powered off state.

```ruby
>> server.stop
true
```

### Restart

This will power off the machine but will set the autoreboot_on flag to true so the VM will be started back up automatically when BigV detects it has stopped.

```ruby
>> server.restart
true
```

### Reboot

This will send the ctrl-alt-delete keys, which will (subject to support from the guest operating system) cause the OS to initiate a shutdown and restart.

```ruby
>> server.reboot
true
```

### Shutdown

This will send an ACPI powerdown signal to the machine which should (subject to support on the guest operating system, cause it to initiate a clean shutdown - the equivalent of pressing a soft power button on a PC. Note that if the autoreboot_on attribute is set to true, BigV will power the machine on again when it detects it has turned off.

```ruby
>> server.shutdown
true
```

### Reset

This will send an ACPI reset signal to the machine which is equivalent to pressing the reset button. The virtual machine will reset, but will continue to use the same process on the host, so things like size changes will not take effect like they will with the above methods.

```ruby
>> server.reset
true
```

### wait_for

The wait_for method blocks (does not return) until the condition in the supplied block completes execution - great for after server creation!

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

### Update an existing server

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


### Sendkey

This sends a key press (or key presses) to the server.

```ruby
>> server.sendkey('ctrl-alt-delete')
true
```


### Delete a server

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


### Undelete a server

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


### Purge a server

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


### Re-image a server

If you would like to re-image (re-install) a virtual machine, you can use the reimage method. This takes distribution and root_password as parameters, the same as when creating a VM. This can only be performed on a Virtual Machine which is powered off. Once complete, the machine will be left powered on. Note that the autoreboot_on attribute is not changed and therefore will still be set to false. You should update it to true if you would like the 

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


## Discs

You can get the discs on the virtual machine by using:

```ruby
>> server.discs
  <Fog::Compute::BigV::Discs
    [
      <Fog::Compute::BigV::Disc
        id=13068,
        server_id=12610,
        group_id=1,
        label="vda",
        size=20480,
        storage_pool="tail04-sata2",
        storage_grade="sata"
      >
    ]
  >
```

This (like servers) acts like an array:

```ruby
>> server.discs.count
1

>> server.discs?
true

>> server.discs.first
  <Fog::Compute::BigV::Disc
    id=13068,
    server_id=12610,
    group_id=1,
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
        server_id=12610,
        group_id=1,
        label="vda",
        size=20480,
        storage_pool="tail04-sata2",
        storage_grade="sata"
      >
    ]
  >
```

### View specific disc

```ruby
>> disc = server.discs.get('backups')
  <Fog::Compute::BigV::Disc
    id=14195,
    server_id=12610,
    group_id=1,
    label="backups",
    size=10240,
    storage_pool="tail08-archive1",
    storage_grade="archive"
  >

>> disc = server.discs.get(14195)
  <Fog::Compute::BigV::Disc
    id=14195,
    server_id=12610,
    group_id=1,
    label="backups",
    size=10240,
    storage_pool="tail08-archive1",
    storage_grade="archive"
  >
```

### Add a Disc

```ruby
>> server.discs
  <Fog::Compute::BigV::Discs
    [
      <Fog::Compute::BigV::Disc
        id=14157,
        server_id=12610,
        group_id=1,
        label="vda",
        size=20480,
        storage_pool="tail04-sata2",
        storage_grade="sata"
      >
    ]
  >
>> server.discs.count
1

>> server.discs.create(:label => 'backups', :size => 10240, :storage_grade => 'archive')
  <Fog::Compute::BigV::Disc
    id=14195,
    server_id=12610,
    group_id=1,
    label="backups",
    size=10240,
    storage_pool="tail08-archive1",
    storage_grade="archive"
  >

>> server.discs.count
2

>> server.discs
  <Fog::Compute::BigV::Discs
    [
      <Fog::Compute::BigV::Disc
        id=14157,
        server_id=12610,
        group_id=1,
        label="vda",
        size=20480,
        storage_pool="tail04-sata2",
        storage_grade="sata"
      >,
      <Fog::Compute::BigV::Disc
        id=14195,
        server_id=12610,
        group_id=1,
        label="backups",
        size=10240,
        storage_pool="tail08-archive1",
        storage_grade="archive"
      >
    ]
  >
```

Note that the VM will not see the disc until after a reboot.

### Update a disc

Todo - currently not working.

### Delete a disc

This can only be performed on a server which is turned off.

```ruby
>> server.stop
true

>> server.discs.get('backups').destroy
true
 ```


## Nics (network interfaces)

You can get all of the nics on the virtual machine by using:

```ruby
>> server.nics
  <Fog::Compute::BigV::Nics
    [
      <Fog::Compute::BigV::Nic
        id=12728,
        server_id=12610,
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
    server_id=12610,
    label=nil,
    ips=["213.xxx.xxx.xxx", "2001:ffff:ff:fff:ffff:ff:ffff:ffff"],
    vlan_num=750,
    mac="fe:ff:00:00:ff:ff",
    extra_ips={}
  >
```

### IP Addresses

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
        server_id=12610,
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
    server_id=12610,
    label=nil,
    ips=["213.xxx.xxx.xxx", "2001:ffff:ff:fff:ffff:ff:ffff:ffff"],
    vlan_num=750,
    mac="fe:ff:00:00:ff:ff",
    extra_ips={}
  >
```


## Iteration

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

### All groups

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

### Specific group by ID

```ruby
  >> b.groups.get(1)
      <Fog::Compute::BigV::Group
        id=1,
        name="default"
      >
```

### Specific group by Name

```ruby
>> b.groups.get('default')
      <Fog::Compute::BigV::Group
        id=1,
        name="default"
      >
```


### Add a new group

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

### Update a group

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

### Delete a group

```ruby
>> group.destroy
true

>> bigv.groups.map(&:name)
["default", "test1", "test2"]
```

### Servers in group

```ruby
>> bigv.servers.count
6

>> bigv.groups.first
  <Fog::Compute::BigV::Group
    id=123,
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


## Users

Users are generally physical people - there can be multiple users (people) accessing a single account. Users have privileges detailing what accounts, groups and/or virtual machines they can access and under what circumstances.

### Get all users

```ruby
>> bigv.users
  <Fog::Compute::BigV::Users
    [
      <Fog::Compute::BigV::User
        id=1,
        username="myusername",
        email="email@mydomain.com",
        authorized_keys="ssh-rsa AAAA....... myuser@myhost"
      >
    ]
```

### Get an individual user

```ruby
>> bigv.users.get(1)
  <Fog::Compute::BigV::User
    id=1,
    username="myusername",
    email="email@mydomain.com",
    authorized_keys="ssh-rsa AAAA....... myuser@myhost"
  >

>> bigv.users.get('myusername')
  <Fog::Compute::BigV::User
    id=1,
    username="myusername",
    email="email@mydomain.com",
    authorized_keys="ssh-rsa AAAA....... myuser@myhost"
  >
```

### Add a new user

```ruby
>> bigv.users.count
1

>> bigv.users.create(:username => 'mynewusername', :email => 'myemail@mydomain.com')
  <Fog::Compute::BigV::User
    id=2,
    username="mynewusername",
    email="myemail@mydomain.com",
    authorized_keys=nil
  >

>> bigv.users.count
2

>> b.users
  <Fog::Compute::BigV::Users
    [
      <Fog::Compute::BigV::User
        id=1,
        username="myusername",
        email="email@mydomain.com",
        authorized_keys="ssh-rsa AAAA....... myuser@myhost"
      >,
      <Fog::Compute::BigV::User
        id=2,
        username="mynewusername",
        email="myemail@mydomain.com",
        authorized_keys=nil
      >
    ]
  >
```

### Update a user

Once a user has been created, the username and email can not be changed so only authorized_keys and password can be updated.

```ruby
>> user = b.users.get('mynewusername')
  <Fog::Compute::BigV::User
    id=2,
    username="mynewusername",
    email="myemail@mydomain.com",
    authorized_keys=nil
  >

>> user.authorized_keys = 'ssh-rsa AAAA....... myuser@myhost'
"ssh-rsa AAAA....... myuser@myhost"

>> user.save
  <Fog::Compute::BigV::User
    id=2,
    username="mynewusername",
    email="myemail@mydomain.com",
    authorized_keys="ssh-rsa AAAA....... myuser@myhost"
  >

>> user.password = 'newpassword'
"newpassword"

>> user.save
  <Fog::Compute::BigV::User
    id=2,
    username="mynewusername",
    email="myemail@mydomain.com",
    authorized_keys="ssh-rsa AAAA....... myuser@myhost"
  >
```

### Delete a user

```ruby
>> bigv.users.get('mynewusername').destroy
true
```


## Accounts

Accounts are a billable entity. Accounts would generally relate to a company, organisation, or maybe a persion. An account can be accessed by multiple users (eg: employees) and a user can access multiple accounts (so the same user could for example, access the accounts of multiple companies and/or have a personal account). Accounts contain groups and virtual machines.

### Get all accounts

```ruby
>> bigv.accounts
  <Fog::Compute::BigV::Accounts
    [
      <Fog::Compute::BigV::Account
        id=1,
        name="myaccountname"
      >
    ]
  >
```

### Get specific account

```ruby
>> bigv.accounts.get(1)
  <Fog::Compute::BigV::Account
    id=1,
    name="myaccountname"
  >

>> bigv.accounts.get('myaccountname')
  <Fog::Compute::BigV::Account
    id=1,
    name="myaccountname"
  >
```

### Add a new account

```ruby
>> bigv.accounts.count
1

>> bigv.accounts.create(:name => 'my-test-account')
  <Fog::Compute::BigV::Account
    id=2,
    name="my-test-account"
  >

>> bigv.accounts.count
2

>> bigv.accounts
  <Fog::Compute::BigV::Accounts
    [
      <Fog::Compute::BigV::Account
        id=1,
        name="myaccountname"
      >,

      <Fog::Compute::BigV::Account
        id=2,
        name="my-test-account"
      >
    ]
  >

>> bigv.accounts.get('my-test-account')
  <Fog::Compute::BigV::Account
    id=2,
    name="my-test-account"
  >
```


## Privileges

Privileges contain what a user can do, and under what circumstances.

For example, a user can be an 'account admin' for an account, a 'group admin' for a group or a 'vm admin' for a virtual machine. They could however only be a group admin over a group if they use their Yubikey and/or are coming from a certain ip address.

### Get all privileges

```ruby
>> bigv.privileges
  <Fog::Compute::BigV::Privileges
    [
      <Fog::Compute::BigV::Privilege
        id=1,
        virtual_machine_id=nil,
        group_id=nil,
        account_id=1,
        username="myusername",
        level="account_admin",
        creating_username=nil,
        yubikey_required=false,
        yubikey_otp_max_age=nil,
        ip_restrictions=nil
      >,
      <Fog::Compute::BigV::Privilege
        id=2,
        virtual_machine_id=nil,
        group_id=nil,
        account_id=2,
        username="myusername",
        level="account_admin",
        creating_username=nil,
        yubikey_required=false,
        yubikey_otp_max_age=nil,
        ip_restrictions=nil
      >,
      <Fog::Compute::BigV::Privilege
        id=3,
        virtual_machine_id=nil,
        group_id=1,
        account_id=nil,
        username="anotherusername",
        level="group_admin",
        creating_username=nil,
        yubikey_required=false,
        yubikey_otp_max_age=nil,
        ip_restrictions=nil
      >
    ]
  >
```

### Get a specific privilege

```ruby
>> bigv.privileges.get(1)
  <Fog::Compute::BigV::Privilege
    id=1,
    virtual_machine_id=nil,
    group_id=nil,
    account_id=1,
    username="myusername",
    level="account_admin",
    creating_username=nil,
    yubikey_required=false,
    yubikey_otp_max_age=nil,
    ip_restrictions=nil
  >
```

### Get all privileges for a specific user

``ruby
  >> bigv.users.get('anotherusername').privileges
  <Fog::Compute::BigV::Privileges
    [
      <Fog::Compute::BigV::Privilege
        id=3,
        virtual_machine_id=nil,
        group_id=1,
        account_id=nil,
        username="anotherusername",
        level="group_admin",
        creating_username=nil,
        yubikey_required=false,
        yubikey_otp_max_age=nil,
        ip_restrictions=nil
      >
    ]
  >
```

### Create a new privilege

You can only create privileges at levels beneath you. As an account admin (default), you can create privileges for group_admin or vm_admin, but not account_admin - you'll need to contact support for that.

This will let user 'someuser' be a 'group admin' for group_id 2 (without the need for a yubikey):

```ruby
>> bigv.users.get('someuser').privileges.create(:level => 'group_admin', :group_id => 2, :yubikey_required => false)
  <Fog::Compute::BigV::Privilege
    id=4,
    virtual_machine_id=nil,
    group_id=2,
    account_id=nil,
    username="someuser",
    level="group_admin",
    creating_username="myusername",
    yubikey_required=false,
    yubikey_otp_max_age=nil,
    ip_restrictions=nil
  >
```

You could refer to the group by name:

```ruby
bigv.users.get('someuser').privileges.create(:level => 'group_admin', :group_id => bigv.groups.get('mygroup').id, :yubikey_required => false)
```

Or you could actually provide the user_id as a parameter:

```ruby
>> bigv.privileges.create(:user_id => 3, :level => 'group_admin', :group_id => 2, :yubikey_required => false)
  <Fog::Compute::BigV::Privilege
    id=4,
    virtual_machine_id=nil,
    group_id=2,
    account_id=nil,
    username="someuser",
    level="group_admin",
    creating_username="myusername",
    yubikey_required=false,
    yubikey_otp_max_age=nil,
    ip_restrictions=nil
  >
```


### Update a privilege

You can update the yubikey_required, yubikey_otp_max_age and ip_restrictions (again, only on privileges on lower levels than your own though).

```ruby
>> priv = bigv.privileges.get(4)
  <Fog::Compute::BigV::Privilege
    id=4,
    virtual_machine_id=nil,
    group_id=2,
    account_id=nil,
    username="someuser",
    level="group_admin",
    creating_username="myusername",
    yubikey_required=false,
    yubikey_otp_max_age=nil,
    ip_restrictions=nil
  >

>> priv.yubikey_required = true
true

>> priv.yubikey_otp_max_age = 900
900

>> priv.save
  <Fog::Compute::BigV::Privilege
    id=4,
    virtual_machine_id=nil,
    group_id=2,
    account_id=nil,
    username="someuser",
    level="group_admin",
    creating_username="myusername",
    yubikey_required=true,
    yubikey_otp_max_age=900,
    ip_restrictions=nil
  >
```

### Delete a privilege

```ruby
>> b.privileges.get(4).destroy
true
```
