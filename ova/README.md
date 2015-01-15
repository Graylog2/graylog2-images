Graylog2 *OVA* appliance
========================

### Usage

  * Download the image [here](https://packages.graylog2.org/releases/graylog2-omnibus/ova/graylog2.ova)
  * For VmWare Player/Fusion right click on the image and select 'Run with VmWare'
  * For Virtualbox select File->Import Appliance
  * If not automatically, start the VM
  * Wait some minutes until all services are running
  * Open the Graylog2 web interface with the displayed URL from the console
  * Login with user `admin`, password `admin`

### Configuration

You can login to the console of the appliance with username and password `ubuntu`.
There you can set a couple of options through `graylog2-ctl` without touching actual configuration files.

| Command | Configuration Option |
|---------|----------------------|
| `graylog2-ctl set-admin-password <password>` | Set a new admin password |
| `graylog2-ctl set-admin-username <username>` | Set a diferent username for the admin user |
| `graylog2-ctl set-email-config <smtp server> [--port=<smtp port> --user=<username> --password=<password>]` | Configure SMTP settings to send alert mails |
| `graylog2-ctl set-timezone <zone acronym>` | Set the timezone your setup is located in |

After setting one or more of these options re-run

```shell
$ graylog2-ctl reconfigure
```

to enable the changed configuration.

You can also edit the full configuration files under `/opt/graylog2/conf` manually, restart the related service afterwards

```shell
$ graylog2-ctl restart graylog2-server
```

Or to restart all services

```shell
$ graylog2-ctl restart
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
| `graylog2-ctl reconfigure` | Run all services on this box |
| `graylog2-ctl reconfigure-as-backend` | Run graylog2-server, elasticsearch and mongodb |
| `graylog2-ctl reconfigure-as-webinterface` | Only the web interface|
| `graylog2-ctl reconfigure-as-datanode` | Only elasticsearch |
| `graylog2-ctl reconfigure-as-server` | Run graylog2-server and mongodb (no elasticsearch) |
