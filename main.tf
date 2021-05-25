terraform {
  required_version = ">=v0.12.20"

  backend "s3" {
    encrypt = true
    acl     = "private"
    bucket  = "abc-343-dev-us-east-1-167-terraform"
    key     = "dev1.tfstate"
    dynamodb_table = "abc-343-dev-us-east-1-167-terraform"

  }
}

provider "aws" {
  region = var.region
}


module "ec2" {
  source                      = "./modules/ec2"
  region                      = var.region
  #ec2_host_key_pair          = var.ec2_host_key_pair
  ec2ami                     = var.ec2ami
  kms_key_id                  = var.kms_key_id
  auto_scaling_group_subnets  = var.auto_scaling_group_subnets
  instancetype               = var.instancetype
  iaminstanceprofile        = var.iaminstanceprofile
  ec2securitygroups         = var.ec2securitygroups
  tags                        = var.tags
  ec2_lt_name_tag             = var.ec2_lt_name_tag
  asg_resource_name           = var.asg_resource_name
  lt_resource_name            = var.lt_resource_name
  public_ssh_port             = var.public_ssh_port
  ebs_volume_size             = var.ebs_volume_size
  associate_public_ip_address = var.associate_public_ip_address
}

