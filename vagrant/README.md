*Vagrant* Graylog2 box
==================================
This project creates a Vagrant box with full Graylog2 stack installed.

Requirements
------------
You need a recent `vagrant` version, get it [here](https://www.vagrantup.com/downloads.html).
Copy the `Vagrantfile` to a local folder and execute

```shell
$ vagrant up
```

This will create a local VM and downloads Graylog2.

Usage
-----
After downloading all software packages, your Graylog2 instance is ready to use.
You can reach the web interface by pointing your browser to localhost: `http://localhost:9000`

The default login is `Username: admin Password: admin`. You can change the admin password by executing
these commands inside the VM

```shell
$ vagrant ssh
$ sudo graylog2-ctl set-admin-password !SeCreTPasSwOrD?
$ sudo graylog2-ctl reconfigure
```
