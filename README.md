# graylog2-Images

This project allows you to create machine images with a full Graylog stack installed.


Graylog *OVA* appliance
=======================

### Pre-Considerations

  * Please run this appliance always in a separated network that is isolated from the internet.

### Dependencies

  * 64bit host system with Virtualbox/VMWare/XenServer hypervisor

### Download

  * Stable branch (3.3.5): [graylog.ova](https://downloads.graylog.org/releases/graylog-omnibus/ova/graylog-3.3.5-1.ova)

Detailed documentation can be found [here](http://docs.graylog.org/en/latest/pages/installation/virtual_machine_appliances.html).


Create machine images with *Packer*
==================================
This project creates machine images with a full Graylog stack installed.

Requirements
------------
You need a recent `packer` version, get it [here](https://www.packer.io/downloads.html).
To set your local properties copy the packerrc.sh.example to packerrc.sh and fill in the right values for your environment.
Before you run `packer` source the packerrc.sh in your terminal.

```shell
$ cd packer
$ . packerrc.sh
$ packer build aws.json
```

This e.g. creates an Amazon AMI for you.

Usage
-----
We install in all machine images our Omnibus package that comes with the `graylog-ctl` command.
After spinning up the VM you have to login with the `ubuntu` user and execute at least

```shell
$ sudo graylog-ctl reconfigure
```

This will setup your Graylog installation and start all services. You can reach the web interface by
pointing your browser to the IP of the appliance: `http://<IP address>:9000`

The default login is `Username: admin Password: admin`. You can change the admin password:

```shell
$ sudo graylog-ctl set-admin-password !SeCreTPasSwOrD?
$ sudo graylog-ctl reconfigure
```

Noticeable Options
------------------
### AWS

|Parameter | Value |
|----------|-------|
|type      |Choose AWS storage type, EBS works fine for the beginning|
|ami_groups | 'all' means publicly available|
|ami_regions | Array of availability zones to copy the image after creation|


### Virtualbox

|Parameter | Value |
|----------|-------|
|disk_size | Set the maximum disk size for the image|
|modifyvm --memory | RAM size|
|modifyvm --cpus | Number of CPUs|
|modifyvm --natpf1 | Default port forwards|


AMI Images
==========
AWS EC2 Images can be found [here](https://github.com/Graylog2/graylog2-images/tree/3.3/aws)
