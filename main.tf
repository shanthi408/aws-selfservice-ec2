terraform {
  required_version = ">=v0.12.20"

  backend "s3" {
    encrypt = true
    acl     = "private"
    bucket  = "abc-343-${var.environment}-${var.region}-167-terraform"
    key     = "${var.appname}.tfstate"
    dynamodb_table = "abc-343-${var.environment}-${var.region}-167-terraform"

    workspaces {
      name = "ec2-${var.environment}-${var.region}"
    }

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
  kmskeyid                  = var.kmskeyid
  autoscalinggroupsubnets  = var.autoscalinggroupsubnets
  instancetype               = var.instancetype
  iaminstanceprofile        = var.iaminstanceprofile
  ec2securitygroups         = var.ec2securitygroups
  tags                        = var.tags
  ec2ltnametag             = var.ec2ltnametag
  asgresourcename           = var.asgresourcename
  ltresourcename            = var.ltresourcename
  public_ssh_port             = var.public_ssh_port
  ebsvolumesize             = var.ebsvolumesize
  associatepublicipaddress = var.associatepublicipaddress
}

