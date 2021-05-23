#region                      = "TF_VAR_region"
instance_type               = "t3.xlarge" ##env.instance_type
ec2_security_groups         = ["sg-dea4b0da"]
iam_instance_profile        = "SSMInstanceProfile"
#ec2_host_key_pair           = "amazon-"
ec2_ami                     = "ami-0d5eff06f840b45e9"
kms_key_id                  = ""
ec2_lt_name_tag             = "env-dev-lt"
asg_resource_name           = "self-service-ec2-asg"
lt_resource_name            = "self-service-ec2-lt"
associate_public_ip_address = false
ebs_volume_size             = "35"

auto_scaling_group_subnets = [
  "subnet-78eb921e",
  "subnet-7380c752"
]

tags = {
  Name               = "dev_ec2"
  Created_By         = "Shanthi"
  Created_Date       = "5/14/2021"
  Organization       = "CSO"
  Owner              = "John Doe"
  Project            = "Self Service EC2"
  Environment        = "Dev"
  Jira_ticket_Number = "CICD-2021"
  Expires            = "12/12/2021"
  OS                 = "Ubuntu"
}
