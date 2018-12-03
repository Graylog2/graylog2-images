AWS EC2 Images
==============

### Pre-Considerations

  * This is a showcase of Graylog and its cluster mode. Please run this appliance always in a separated network that is isolated from the internet.
    Read also the production readiness [notes](http://docs.graylog.org/en/latest/pages/installation/virtual_machine_appliances.html#production-readiness)

### AMIs

| Version   | Region         | AMI                   | Launch Wizard                                                                                                                      |
| --------- | --------       | -----                 | -------------                                                                                                                      |
| 2.5.0     | us-east-1      | ami-067705ee92d398b47 | [Launch instance](https://console.aws.amazon.com/ec2/v2/home?region=us-east-1#LaunchInstanceWizard:ami=ami-067705ee92d398b47)      |
| 2.5.0     | us-east-2      | ami-01d2cdd8801a912ed | [Launch instance](https://console.aws.amazon.com/ec2/v2/home?region=us-east-2#LaunchInstanceWizard:ami=ami-01d2cdd8801a912ed)      |
| 2.5.0     | us-west-1      | ami-0cd6ad478069f1cbe | [Launch instance](https://console.aws.amazon.com/ec2/v2/home?region=us-west-1#LaunchInstanceWizard:ami=ami-0cd6ad478069f1cbe)      |
| 2.5.0     | us-west-2      | ami-06b31dedf53142a0f | [Launch instance](https://console.aws.amazon.com/ec2/v2/home?region=us-west-2#LaunchInstanceWizard:ami=ami-06b31dedf53142a0f)      |
| 2.5.0     | eu-west-1      | ami-052781e76cf0015e9 | [Launch instance](https://console.aws.amazon.com/ec2/v2/home?region=eu-west-1#LaunchInstanceWizard:ami=ami-052781e76cf0015e9)      |
| 2.5.0     | eu-west-2      | ami-07279cdc721d81f13 | [Launch instance](https://console.aws.amazon.com/ec2/v2/home?region=eu-west-2#LaunchInstanceWizard:ami=ami-07279cdc721d81f13)      |
| 2.5.0     | eu-west-3      | ami-05dd423f7d235cfca | [Launch instance](https://console.aws.amazon.com/ec2/v2/home?region=eu-west-3#LaunchInstanceWizard:ami=ami-05dd423f7d235cfca)      |
| 2.5.0     | eu-central-1   | ami-08ff4fbd160758b90 | [Launch instance](https://console.aws.amazon.com/ec2/v2/home?region=eu-central-1#LaunchInstanceWizard:ami=ami-08ff4fbd160758b90)   |
| 2.5.0     | ap-northeast-1 | ami-0b4212dee8836018f | [Launch instance](https://console.aws.amazon.com/ec2/v2/home?region=ap-northeast-1#LaunchInstanceWizard:ami=ami-0b4212dee8836018f) |
| 2.5.0     | ap-southeast-1 | ami-077e1fb0c932ac2c6 | [Launch instance](https://console.aws.amazon.com/ec2/v2/home?region=ap-southeast-1#LaunchInstanceWizard:ami=ami-077e1fb0c932ac2c6) |
| 2.5.0     | ap-southeast-2 | ami-0bfbe34c7b5105ff3 | [Launch instance](https://console.aws.amazon.com/ec2/v2/home?region=ap-southeast-2#LaunchInstanceWizard:ami=ami-0bfbe34c7b5105ff3) |
| 2.5.0     | sa-east-1      | ami-00c2d5c3a2453e653 | [Launch instance](https://console.aws.amazon.com/ec2/v2/home?region=sa-east-1#LaunchInstanceWizard:ami=ami-00c2d5c3a2453e653)      |

### Update Packages

  * Follow update instructions [here](http://docs.graylog.org/en/2.5/pages/installation/graylog_ctl.html#upgrade-graylog)
  * View all Graylog versions available for update [here](https://packages.graylog2.org/appliances/ubuntu)

Detailed documentation can be found [here](http://docs.graylog.org/en/2.5/pages/installation/aws.html).
