AWS EC2 Images
==============

| Version | Region | AMI | Launch Wizard |
|---------|--------|-----|-------------|
| 0.92.4  | us-east-1 | ami-5e1c5736 | [Launch instance](https://console.aws.amazon.com/ec2/v2/home?region=us-east-1#LaunchInstanceWizard:ami=ami-5e1c5736) |
| 0.92.4  | us-west-1 | ami-c8adb68d | [Launch instance](https://console.aws.amazon.com/ec2/v2/home?region=us-west-1#LaunchInstanceWizard:ami=ami-c8adb68d) |
| 0.92.4  | eu-west-1 | ami-0d78f37a | [Launch instance](https://console.aws.amazon.com/ec2/v2/home?region=eu-west-1#LaunchInstanceWizard:ami=ami-0d78f37a) |
| 0.92.4  | eu-central-1 | ami-3a734127 | [Launch instance](https://console.aws.amazon.com/ec2/v2/home?region=eu-central-1#LaunchInstanceWizard:ami=ami-3a734127) |
| 0.92.4  | ap-southeast-2 | ami-639ee959 | [Launch instance](https://console.aws.amazon.com/ec2/v2/home?region=ap-southeast-2#LaunchInstanceWizard:ami=ami-639ee959) |
| 0.92.3  | us-east-1 | ami-a0394ec8| [Launch instance](https://console.aws.amazon.com/ec2/v2/home?region=us-east-1#LaunchInstanceWizard:ami=ami-a0394ec8) |
| 0.92.3  | us-west-1 | ami-ebb1adae | [Launch instance](https://console.aws.amazon.com/ec2/v2/home?region=us-west-1#LaunchInstanceWizard:ami=ami-ebb1adae) |
| 0.92.3  | eu-west-1 | ami-9469ede3 | [Launch instance](https://console.aws.amazon.com/ec2/v2/home?region=eu-west-1#LaunchInstanceWizard:ami=ami-9469ede3) |
| 0.92.3  | eu-central-1 | ami-08dbeb15 | [Launch instance](https://console.aws.amazon.com/ec2/v2/home?region=eu-central-1#LaunchInstanceWizard:ami=ami-08dbeb15) |
| 0.92.1  | us-east-1 | ami-aea4c4c6 | [Launch instance](https://console.aws.amazon.com/ec2/v2/home?region=us-east-1#LaunchInstanceWizard:ami=ami-aea4c4c6) |
| 0.92.1  | us-west-1 | ami-99fbe9dc | [Launch instance](https://console.aws.amazon.com/ec2/v2/home?region=us-west-1#LaunchInstanceWizard:ami=ami-99fbe9dc) |
| 0.92.1  | eu-west-1 | ami-e6388691 | [Launch instance](https://console.aws.amazon.com/ec2/v2/home?region=eu-west-1#LaunchInstanceWizard:ami=ami-e6388691) |
| 0.92.1  | eu-central-1 | ami-b07d4dad | [Launch instance](https://console.aws.amazon.com/ec2/v2/home?region=eu-central-1#LaunchInstanceWizard:ami=ami-b07d4dad) |


### Usage

  * Click on 'Launch instance' for your AWS region to start Graylog into.
  * Finish the wizard and spin up the VM.
  * Login to the instance as user `ubuntu`
  * Run `sudo graylog-ctl reconfigure`
  * Access Graylog by pointing your browser to the instance IP port 9000 `http://<instance ip>:9000`
  * Login with user `admin`, password `admin`
 
 You can change the password with the command `sudo graylog-ctl set-admin-password <your new password>` and
 rerun `sudo graylog-ctl reconfigure`

