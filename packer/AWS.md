AWS EC2 Images
==============

| Version | Region | AMI | Launch Wizard |
|---------|--------|-----|-------------|
| 0.91.1  | us-east-1 | ami-b461e7dc | [Launch instance](https://console.aws.amazon.com/ec2/v2/home?region=us-east-1#LaunchInstanceWizard:ami=ami-b461e7dc) |
| 0.91.1  | us-west-1 | ami-e1697da4 | [Launch instance](https://console.aws.amazon.com/ec2/v2/home?region=us-west-1#LaunchInstanceWizard:ami=ami-e1697da4) |
| 0.91.1  | eu-west-1 | ami-d6be17a1 | [Launch instance](https://console.aws.amazon.com/ec2/v2/home?region=eu-west-1#LaunchInstanceWizard:ami=ami-d6be17a1) |


### Usage

  * Click on 'Launch instance' for your AWS region to start Graylog2 into.
  * Finish the wizard and spin up the VM.
  * Login to the instance as user `ubuntu`
  * Run `sudo graylog2-ctl reconfigure`
  * Access the Graylog2 by pointing your browser to the instance IP port 9000 `http://<instance ip>:9000`
  * Login with user `admin`, password `admin`
 
 You can change the password with the command `sudo graylog2-ctl set-admin-password <your new password>` and
 rerun `sudo graylog2-ctl reconfigure`

