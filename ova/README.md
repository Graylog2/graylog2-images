Graylog2 *OVA* appliance
========================

### Usage

  * Download the image [here](https://packages.graylog2.org/releases/graylog2-omnibus/ova/graylog2.ova)
  * For VmWare Player/Fusion right click on the image and select 'Run with VmWare'
  * For Virtualbox select File->Import Appliance
  * Login to the instance as user `ubuntu` with password `ubuntu`
  * Run `sudo graylog2-ctl reconfigure`
  * Get the IP address of your instance `ifconfig eth0`
  * Access Graylog2 by pointing your browser to the instance IP `http://<instance ip>`
  * Login with user `admin`, password `admin`
