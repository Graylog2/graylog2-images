AWS EC2 Images
==============

| Version | Region | AMI | Launch Wizard |
|---------|--------|-----|-------------|
| 0.92.4  | us-east-1 | ami-3283fe5a | [Launch instance](https://console.aws.amazon.com/ec2/v2/home?region=us-east-1#LaunchInstanceWizard:ami=ami-3283fe5a) |
| 0.92.4  | us-west-1 | ami-fd7e60b8 | [Launch instance](https://console.aws.amazon.com/ec2/v2/home?region=us-west-1#LaunchInstanceWizard:ami=ami-fd7e60b8) |
| 0.92.4  | eu-west-1 | ami-951c9de2 | [Launch instance](https://console.aws.amazon.com/ec2/v2/home?region=eu-west-1#LaunchInstanceWizard:ami=ami-951c9de2) |
| 0.92.4  | eu-central-1 | ami-4c714251 | [Launch instance](https://console.aws.amazon.com/ec2/v2/home?region=eu-central-1#LaunchInstanceWizard:ami=ami-4c714251) |
| 0.92.4  | ap-southeast-2 | ami-b577038f | [Launch instance](https://console.aws.amazon.com/ec2/v2/home?region=ap-southeast-2#LaunchInstanceWizard:ami=ami-b577038f) |
| 0.92.3  | us-east-1 | ami-a0394ec8| [Launch instance](https://console.aws.amazon.com/ec2/v2/home?region=us-east-1#LaunchInstanceWizard:ami=ami-a0394ec8) |
| 0.92.3  | us-west-1 | ami-ebb1adae | [Launch instance](https://console.aws.amazon.com/ec2/v2/home?region=us-west-1#LaunchInstanceWizard:ami=ami-ebb1adae) |
| 0.92.3  | eu-west-1 | ami-9469ede3 | [Launch instance](https://console.aws.amazon.com/ec2/v2/home?region=eu-west-1#LaunchInstanceWizard:ami=ami-9469ede3) |
| 0.92.3  | eu-central-1 | ami-08dbeb15 | [Launch instance](https://console.aws.amazon.com/ec2/v2/home?region=eu-central-1#LaunchInstanceWizard:ami=ami-08dbeb15) |
| 0.92.1  | us-east-1 | ami-aea4c4c6 | [Launch instance](https://console.aws.amazon.com/ec2/v2/home?region=us-east-1#LaunchInstanceWizard:ami=ami-aea4c4c6) |
| 0.92.1  | us-west-1 | ami-99fbe9dc | [Launch instance](https://console.aws.amazon.com/ec2/v2/home?region=us-west-1#LaunchInstanceWizard:ami=ami-99fbe9dc) |
| 0.92.1  | eu-west-1 | ami-e6388691 | [Launch instance](https://console.aws.amazon.com/ec2/v2/home?region=eu-west-1#LaunchInstanceWizard:ami=ami-e6388691) |
| 0.92.1  | eu-central-1 | ami-b07d4dad | [Launch instance](https://console.aws.amazon.com/ec2/v2/home?region=eu-central-1#LaunchInstanceWizard:ami=ami-b07d4dad) |


### Usage

  * Click on 'Launch instance' for your AWS region to start Graylog2 into.
  * Finish the wizard and spin up the VM.
  * Login to the instance as user `ubuntu`
  * Run `sudo graylog2-ctl reconfigure`
  * Access Graylog2 by pointing your browser to the instance IP port 9000 `http://<instance ip>:9000`
  * Login with user `admin`, password `admin`
 
 You can change the password with the command `sudo graylog2-ctl set-admin-password <your new password>` and
 rerun `sudo graylog2-ctl reconfigure`

