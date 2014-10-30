AWS EC2 Images
==============

| Version | Region | AMI | ec2 command |
|---------|--------|-----|-------------|
| 0.91.1  | us-east-1 | ami-b461e7dc | `ec2-run-instances ami-b461e7dc -t m3.medium --region us-east-1 --key ${EC2_KEYPAIR_US_EAST_1}` |
| 0.91.1  | us-west-1 | ami-e1697da4 | `ec2-run-instances ami-e1697da4 -t m3.medium --region us-west-1 --key ${EC2_KEYPAIR_US_WEST_1}` |
| 0.91.1  | eu-west-1 | ami-d6be17a1 | `ec2-run-instances ami-d6be17a1 -t m3.medium --region eu-west-1 --key ${EC2_KEYPAIR_EU_WEST_1}` |


### Usage

  * Spin up your instance with the given command or use the web interface with the given AMI ID.
  * Login to the instance as user `ubuntu`
  * Run `sudo graylog2-ctl reconfigure`
  * Access the Graylog2 by pointing your browser to the instance IP port 9000 `http://<instance ip>:9000`
  * Login with user `admin`, password `admin`
 
 You can change the password with the command `sudo graylog2-ctl set-admin-password <your new password>` and
 rerun `sudo graylog2-ctl reconfigure`

