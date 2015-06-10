AWS EC2 Images
==============

| Version | Region | AMI | Launch Wizard |
|---------|--------|-----|-------------|
| 1.1.2  | us-east-1 | ami-8f6590e4 | [Launch instance](https://console.aws.amazon.com/ec2/v2/home?region=us-east-1#LaunchInstanceWizard:ami=ami-8f6590e4) |
| 1.1.2  | us-west-1 | ami-27709a63 | [Launch instance](https://console.aws.amazon.com/ec2/v2/home?region=us-west-1#LaunchInstanceWizard:ami=ami-27709a63) |
| 1.1.2  | us-west-2 | ami-fd9ea6cd | [Launch instance](https://console.aws.amazon.com/ec2/v2/home?region=us-west-2#LaunchInstanceWizard:ami=ami-fd9ea6cd) |
| 1.1.2  | eu-west-1 | ami-75bcc202 | [Launch instance](https://console.aws.amazon.com/ec2/v2/home?region=eu-west-1#LaunchInstanceWizard:ami=ami-75bcc202) |
| 1.1.2  | eu-central-1 | ami-aa7149b7 | [Launch instance](https://console.aws.amazon.com/ec2/v2/home?region=eu-central-1#LaunchInstanceWizard:ami=ami-aa7149b7) |
| 1.1.2  | ap-southeast-2 | ami-63582359 | [Launch instance](https://console.aws.amazon.com/ec2/v2/home?region=ap-southeast-2#LaunchInstanceWizard:ami=ami-63582359) |
| 1.1.1  | us-east-1 | ami-9bb950f0 | [Launch instance](https://console.aws.amazon.com/ec2/v2/home?region=us-east-1#LaunchInstanceWizard:ami=ami-9bb950f0) |
| 1.1.1  | us-west-1 | ami-878d67c3 | [Launch instance](https://console.aws.amazon.com/ec2/v2/home?region=us-west-1#LaunchInstanceWizard:ami=ami-878d67c3) |
| 1.1.1  | us-west-2 | ami-470d3477 | [Launch instance](https://console.aws.amazon.com/ec2/v2/home?region=us-west-2#LaunchInstanceWizard:ami=ami-470d3477) |
| 1.1.1  | eu-west-1 | ami-e9532f9e | [Launch instance](https://console.aws.amazon.com/ec2/v2/home?region=eu-west-1#LaunchInstanceWizard:ami=ami-e9532f9e) |
| 1.1.1  | eu-central-1 | ami-48c9f055 | [Launch instance](https://console.aws.amazon.com/ec2/v2/home?region=eu-central-1#LaunchInstanceWizard:ami=ami-48c9f055) |
| 1.1.1  | ap-southeast-2 | ami-ebf48cd1 | [Launch instance](https://console.aws.amazon.com/ec2/v2/home?region=ap-southeast-2#LaunchInstanceWizard:ami=ami-ebf48cd1) |
| 1.1.0  | us-east-1 | ami-91a44afa | [Launch instance](https://console.aws.amazon.com/ec2/v2/home?region=us-east-1#LaunchInstanceWizard:ami=ami-91a44afa) |
| 1.1.0  | us-west-1 | ami-c355be87 | [Launch instance](https://console.aws.amazon.com/ec2/v2/home?region=us-west-1#LaunchInstanceWizard:ami=ami-c355be87) |
| 1.1.0  | us-west-2 | ami-d9526be9 | [Launch instance](https://console.aws.amazon.com/ec2/v2/home?region=us-west-2#LaunchInstanceWizard:ami=ami-d9526be9) |
| 1.1.0  | eu-west-1 | ami-33c1bc44 | [Launch instance](https://console.aws.amazon.com/ec2/v2/home?region=eu-west-1#LaunchInstanceWizard:ami=ami-33c1bc44) |
| 1.1.0  | eu-central-1 | ami-64e7de79 | [Launch instance](https://console.aws.amazon.com/ec2/v2/home?region=eu-central-1#LaunchInstanceWizard:ami=ami-64e7de79) |
| 1.1.0  | ap-southeast-2 | ami-d193ebeb | [Launch instance](https://console.aws.amazon.com/ec2/v2/home?region=ap-southeast-2#LaunchInstanceWizard:ami=ami-d193ebeb) |

### Usage

  * Click on 'Launch instance' for your AWS region to start Graylog into.
  * Choose an instance type with at least 4GB memory
  * Finish the wizard and spin up the VM.
  * Login to the instance as user `ubuntu`
  * Run `sudo graylog-ctl reconfigure`
  * Open port 80 and ports for receiving log messages in the security group of the appliance

Open `http://<vm ip>` in your browser to access the Graylog web interface. Default username and password is `admin`.

### Configuration

You can set a couple of configuration options through the build-in `graylog-ctl` command. You need super-user
permissions to perform an actual change so don't forget the `sudo`.

| Command | Configuration Option |
|---------|----------------------|
| `sudo graylog-ctl set-admin-password <password>` | Set a new admin password |
| `sudo graylog-ctl set-admin-username <username>` | Set a diferent username for the admin user |
| `sudo graylog-ctl set-email-config <smtp server> [--port=<smtp port> --user=<username> --password=<password>]` | Configure SMTP settings to send alert mails |
| `sudo graylog-ctl set-timezone <zone acronym>` | Set Graylog's [timezone](http://en.wikipedia.org/wiki/List_of_tz_database_time_zones). Make sure system time is also set correctly with `sudo dpkg-reconfigure tzdata` |
| `sudo graylog-ctl set-retention --size=<Gb> OR --time=<hours> --indices=<number> [--journal=<Gb>]` | Configure message retention |
| `sudo graylog-ctl enforce-ssl` | Enforce HTTPS for the web interface |

After setting one or more of these options re-run

```shell
$ sudo graylog-ctl reconfigure
```

to enable the changed configuration.

You can also edit the full configuration files under `/opt/graylog/conf` manually and restart the related service afterwards

```shell
$ sudo graylog-ctl restart graylog-server
```

Or to restart all services

```shell
$ sudo graylog-ctl restart
```

### Multi VM setup

At some point it makes sense to not run all services in one VM anymore. For performance reasons you maybe want to add
more Elasticsearch nodes or want to run the web interface separately from the server components.
You can reach this by changing IP addresses in the Graylog configuration files or you can use our canned configurations which comes
with the `graylog-ctl` command.

The idea is to have one VM which is a central point for other VMs to fetch all needed configuration settings to join your cluster.
Typically the first VM you spin up is used for this task. Automatically an instance of `etcd` is started and filled with the necessary
settings for other hosts.

For example to split the web interface from the rest of the setup, spin up two VMs from the same `graylog` image.
On the first only start `graylog-server`, `elasticsearch` and `mongodb`.

```shell
vm1> sudo graylog-ctl set-admin-password sEcReT
vm1> sudo graylog-ctl reconfigure-as-backend
```

on the second VM, start only the web interface but before set the IP of the first VM to fetch configuration data from.

```shell
vm2> sudo graylog-ctl set-cluster-master <ip-of-vm1>
vm2> sudo graylog-ctl reconfigure-as-webinterface
```

This results in a perfectly fine dual VM setup. However if you want to scale this setup out by adding an additional Elasticsearch node, you can
proceed in the same way.

```shell
vm3> sudo graylog-ctl set-cluster-master <ip-of-vm1>
vm3> sudo graylog-ctl reconfigure-as-datanode
```

The following configuration modes do exist

| Command | Services |
|---------|----------|
| `sudo graylog-ctl reconfigure` | Run all services on this box |
| `sudo graylog-ctl reconfigure-as-backend` | Run graylog-server, elasticsearch and mongodb |
| `sudo graylog-ctl reconfigure-as-webinterface` | Only the web interface|
| `sudo graylog-ctl reconfigure-as-datanode` | Only elasticsearch |
| `sudo graylog-ctl reconfigure-as-server` | Run graylog-server and mongodb (no elasticsearch) |

Assign a static IP
--------------
Per default the appliance make use of DHCP to setup the network. If you want to access Graylog under a static IP please
edit the file `/etc/network/interfaces` like this (just the important lines):

```
auto eth0
iface eth0 inet static
  address <static IP address>
  netmask <netmask>
  gateway <default gateway>
  pre-up sleep 2
```

Activate the new IP and reconfigure Graylog to make use of it.

```shell
$ sudo ifdown eth0 && sudo ifup eth0
$ sudo graylog-ctl reconfigure
```

Wait some time till all services are restarted and running again. Afterwards you should be able to access Graylog with the new IP.

Extend disk space
-----------------
All data is stored in one directory `/var/opt/graylog/data`. In order to extend the disk space mount a second drive
on this path. Make sure to move old data to the new drive before and give the `graylog` user permissions to read and
write here.

Install Graylog server plugins
------------------------------
The Graylog plugin directory is located in `/opt/graylog/plugin/`. Just drop a JAR file there and restart the server
with `graylog-ctl restart graylog-server` to load the plugin.

Install Elasticsearch plugins
-----------------------------
Elasticsearch comes with a helper program to install additional plugins you can call it like this `sudo JAVA_HOME=/opt/graylog/embedded/jre /opt/graylog/elasticsearch/bin/plugin`

Install custom SSL certificates
-------------------------------
During the first `reconfigure` run self signed SSL certificates are generated. You can replace this
certificate with your own to prevent security warnings in your browser. Just drop the key and
combined certificate file here: `/opt/graylog/conf/nginx/ca/graylog.crt` respectively `/opt/graylog/conf/nginx/ca/graylog.key`.
Afterwards restart nginx with `sudo graylog-ctl restart nginx`

Configure Message Retention
---------------------------
Graylog is keeping a defined amount of messages. It is possible to decide whether you want to have a set storage size or a set
time period of messages. Additionally Graylog writes a so called Journal. This is used to buffer messages in case of a unreachable
Elasticsearch backend. To configure those settings use the `set-retention` command:

Retention by disk size:

```
sudo graylog-ctl set-retention --size=3 --indices=10
sudo graylog-ctl reconfigure
```

Indices will be rotated when they reach a size of 3Gb and Graylog will keep up to 10 indices, results in 30Gb maximum disk space.

Retention by time:

```
sudo graylog-ctl set-retention --time=24  --indices=30
sudo graylog-ctl reconfigure
```

Indices will be rotated after 24 hours and 30 indices will be kept.

Both commands can be extended with the `--journal` switch to set the maximum journal size in Gb:

```
sudo graylog-ctl set-retention --time=24  --indices=30 --journal=5
sudo graylog-ctl reconfigure
```


Upgrade Graylog
---------------
Upgrading is currently in development. Please be careful here, the default behavior of the pakage was to remove all
data during an upgrade process. Always perform a full backup or snapshot of the appliance before proceeding. Only upgrade
if the release notes say the next version is a drop-in replacement. The following steps prevent the deletion of
the data directory:

```
wget https://packages.graylog2.org/releases/graylog2-omnibus/ubuntu/graylog_latest.deb
sudo rm /var/lib/dpkg/info/graylog.postrm
sudo graylog-ctl stop
sudo dpkg -G -i graylog_latest.deb
sudo graylog-ctl reconfigure
```

Production readiness
--------------------
You can use this image for small production setups but please consider to harden the security of the box before.

 * Set another password for the default `ubuntu` user
 * Disable remote password logins in `/etc/ssh/sshd_config` and deploy proper ssh keys
 * Seperate the box network-wise from the outside, otherwise Elasticsearch can be reached by anyone

If you want to create your own customised setup take a look at our [Puppet](https://github.com/Graylog2/graylog2-puppet),
[Chef](https://github.com/Graylog2/graylog2-cookbook) or [Ansible](https://github.com/Graylog2/graylog-ansible-role) modules.
