Openstack Graylog2 Image
========================

### Installation

These steps will download the Graylog2 image, uncompress it and import it into the Openstack image store.

```shell
$ wget https://packages.graylog2.org/releases/graylog2-omnibus/qcow2/graylog2.qcow2.gz
$ gunzip graylog2.qcow2.gz
$ glance image-create --name='graylog2' --is-public=true --container-format=bare --disk-format=qcow2 --file graylog2.qcow2
```

You should now see an image called `graylog2` in the Openstack web interface under `Images`

### Usage
Launch a new instance of the image, make sure to reserve at least 4GB ram for the instance. After spinning up, login with
the username `ubuntu` and your selected ssh key. Run the reconfigure program in order to setup Graylog2 and start all services.

```shell
ssh ubuntu@<vm IP>
sudo graylog2-ctl reconfigure
```

Open `http://<vm ip>` in your browser to access the Graylog2 web interface. Default username and password is `admin`.

### Configuration

You can set a couple of configuration options through the build-in `graylog2-ctl` command. You need super-user
permissions to perform an actual change so don't forget the `sudo`.

| Command | Configuration Option |
|---------|----------------------|
| `sudo graylog2-ctl set-admin-password <password>` | Set a new admin password |
| `sudo graylog2-ctl set-admin-username <username>` | Set a diferent username for the admin user |
| `sudo graylog2-ctl set-email-config <smtp server> [--port=<smtp port> --user=<username> --password=<password>]` | Configure SMTP settings to send alert mails |
| `sudo graylog2-ctl set-timezone <zone acronym>` | Set the timezone your setup is located in |

After setting one or more of these options re-run 

```shell
$ sudo graylog2-ctl reconfigure
```

to enable the changed configuration.

You can also edit the full configuration files under `/opt/graylog2/conf` manually, restart the related service afterwards

```shell
$ sudo graylog2-ctl restart graylog2-server
```

Or to restart all services

```shell
$ sudo graylog2-ctl restart
```

### Multi VM setup

At some point it makes sense to not run all services in one VM anymore. For performance reasons you maybe want to add
more Elasticsearch nodes or want to run the web interface separately from the server components.
You can reach this by changing IP addresses in the Graylog2 configuration files or you can use our canned configurations which comes
with the `graylog2-ctl` command.

The idea is to have one VM which is a central point for other VMs to fetch all needed configuration settings to join your cluster.
Typically the first VM you spin up is used for this task. Automatically an instance of `etcd` is started and filled with the necessary
settings for other hosts.

For example to split the web interface from the rest of the setup, spin up two VMs from the same `graylog2` image.
On the first only start `graylog2-server`, `elasticsearch` and `mongodb`.

```shell
vm1> sudo graylog2-ctl set-admin-password sEcReT
vm1> sudo graylog2-ctl reconfigure-as-backend
```

on the second VM, start only the web interface but before set the IP of the first VM to fetch configuration data from.

```shell
vm2> sudo graylog2-ctl set-cluster-master <ip-of-vm1>
vm2> sudo graylog2-ctl reconfigure-as-webinterface
```

This results in a perfectly fine dual VM setup. However if you want to scale this setup out by adding an additional Elasticsearch node, you can
proceed in the same way.

```shell
vm3> sudo graylog2-ctl set-cluster-master <ip-of-vm1>
vm3> sudo graylog2-ctl reconfigure-as-datanode
```

The following configuration modes do exist

| Command | Services |
|---------|----------|
| `sudo graylog2-ctl reconfigure` | Run all services on this box |
| `sudo graylog2-ctl reconfigure-as-backend` | Run graylog2-server, elasticsearch and mongodb |
| `sudo graylog2-ctl reconfigure-as-webinterface` | Only the web interface|
| `sudo graylog2-ctl reconfigure-as-datanode` | Only elasticsearch |
| `sudo graylog2-ctl reconfigure-as-server` | Run graylog2-server and mongodb (no elasticsearch) |

Production readiness
--------------------
You can use this image for small production setups but please consider to harden the security of the box before.

 * Set another password for the default `ubuntu` user
 * Disable remote password logins in `/etc/ssh/sshd_config` and deploy proper ssh keys
 * Seperate the box network-wise from the outside, otherwise Elasticsearch can be reached by anyone

If you want to create your own customised setup take a look at our [Puppet](https://github.com/Graylog2/graylog2-puppet)
and [Chef](https://github.com/Graylog2/graylog2-cookbook) modules.
