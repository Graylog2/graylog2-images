AWS EC2 Images
==============

| Version | Region | AMI | Launch Wizard |
|---------|--------|-----|-------------|
| 0.92.1  | us-east-1 | ami-aea4c4c6 | [Launch instance](https://console.aws.amazon.com/ec2/v2/home?region=us-east-1#LaunchInstanceWizard:ami=ami-aea4c4c6) |
| 0.92.1  | us-west-1 | ami-99fbe9dc | [Launch instance](https://console.aws.amazon.com/ec2/v2/home?region=us-west-1#LaunchInstanceWizard:ami=ami-99fbe9dc) |
| 0.92.1  | eu-west-1 | ami-e6388691 | [Launch instance](https://console.aws.amazon.com/ec2/v2/home?region=eu-west-1#LaunchInstanceWizard:ami=ami-e6388691) |
| 0.92.1  | eu-central-1 | ami-b07d4dad | [Launch instance](https://console.aws.amazon.com/ec2/v2/home?region=eu-central-1#LaunchInstanceWizard:ami=ami-b07d4dad) |
| 0.91.3  | us-east-1 | ami-54d35d3c | [Launch instance](https://console.aws.amazon.com/ec2/v2/home?region=us-east-1#LaunchInstanceWizard:ami=ami-54d35d3c) |
| 0.91.3  | us-west-1 | ami-a7fee9e2 | [Launch instance](https://console.aws.amazon.com/ec2/v2/home?region=us-west-1#LaunchInstanceWizard:ami=ami-a7fee9e2) |
| 0.91.3  | eu-west-1 | ami-a07bd1d7 | [Launch instance](https://console.aws.amazon.com/ec2/v2/home?region=eu-west-1#LaunchInstanceWizard:ami=ami-a07bd1d7) |
| 0.91.3  | eu-central-1 | ami-de6d5cc3 | [Launch instance](https://console.aws.amazon.com/ec2/v2/home?region=eu-central-1#LaunchInstanceWizard:ami=ami-de6d5cc3) |
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

