AWS EC2 Images
==============

### Pre-Considerations

  * This is a showcase of Graylog and its cluster mode. Please run this appliance always in a separated network that is isolated from the internet.
    Read also the production readiness [notes](http://docs.graylog.org/en/latest/pages/installation/virtual_machine_appliances.html#production-readiness)

### AMIs

| Version | Region | AMI | Launch Wizard |
|---------|--------|-----|-------------|
| 2.2.2  | us-east-1 | ami-ac0ad2ba | [Launch instance](https://console.aws.amazon.com/ec2/v2/home?region=us-east-1#LaunchInstanceWizard:ami=ami-ac0ad2ba) |
| 2.2.2  | us-west-1 | ami-9cd48afc | [Launch instance](https://console.aws.amazon.com/ec2/v2/home?region=us-west-1#LaunchInstanceWizard:ami=ami-9cd48afc) |
| 2.2.2  | us-west-2 | ami-603fbd00 | [Launch instance](https://console.aws.amazon.com/ec2/v2/home?region=us-west-2#LaunchInstanceWizard:ami=ami-603fbd00) |
| 2.2.2  | eu-west-1 | ami-175d7471 | [Launch instance](https://console.aws.amazon.com/ec2/v2/home?region=eu-west-1#LaunchInstanceWizard:ami=ami-175d7471) |
| 2.2.2  | eu-central-1 | ami-8c5f8ae3 | [Launch instance](https://console.aws.amazon.com/ec2/v2/home?region=eu-central-1#LaunchInstanceWizard:ami=ami-8c5f8ae3) |
| 2.2.2  | ap-northeast-1 | ami-7ab9ed1d | [Launch instance](https://console.aws.amazon.com/ec2/v2/home?region=ap-northeast-1#LaunchInstanceWizard:ami=ami-7ab9ed1d) |
| 2.2.2  | ap-southeast-1 | ami-7fa4141c | [Launch instance](https://console.aws.amazon.com/ec2/v2/home?region=ap-southeast-1#LaunchInstanceWizard:ami=ami-7fa4141c) |
| 2.2.2  | ap-southeast-2 | ami-79989b1a | [Launch instance](https://console.aws.amazon.com/ec2/v2/home?region=ap-southeast-2#LaunchInstanceWizard:ami=ami-79989b1a) |
| 2.2.2  | sa-east-1 | ami-91e98ffd | [Launch instance](https://console.aws.amazon.com/ec2/v2/home?region=sa-east-1#LaunchInstanceWizard:ami=ami-91e98ffd) |

### Update Packages

  * Follow update instructions [here](http://docs.graylog.org/en/1.2/pages/installation/graylog_ctl.html#upgrade-graylog)
  * View all Graylog versions available for update [here](https://packages.graylog2.org/appliances/ubuntu)

Detailed documentation can be found [here](http://docs.graylog.org/en/latest/pages/installation/aws.html).
