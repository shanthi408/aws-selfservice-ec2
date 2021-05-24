variable "tags" {
  description = "A mapping of tags to assign"
  default     = {}
  type        = map(string)
}

variable "region" {
}


#variable "ec2_host_key_pair" {
#  description = "Select the key pair to use to launch the ec2 host"
#}

variable "ec2_lt_name_tag" {
  description = "ec2 Launch template Name, will also be used for the ASG"
  default     = "gobi.kafka-copy.sandbox-lt"
}

variable "ec2_ami" {
  type        = string
  description = "The AMI that the ec2 Host will use."
  default     = ""
}


variable "kms_key_id" {
  type        = string
  description = "KMS key to encrypt ebs volume"
}

variable "asg_resource_name" {
  type        = string
  description = "ASG resource name"
}

variable "lt_resource_name" {
  type        = string
  description = "LT resource name"
}


variable "auto_scaling_group_subnets" {
  type        = list(string)
  description = "List of subnet were the Auto Scalling Group will deploy the instances"
}

variable "associate_public_ip_address" {
  type = bool
}

variable "ec2_instance_count" {
  default = 1
}

variable "public_ssh_port" {
  description = "Set the SSH port to use from desktop to the ec2"
  default     = 80
}

variable "private_ssh_port" {
  description = "Set the SSH port to use between the ec2 and private instance"
  default     = 80
}

variable "extra_user_data_content" {
  description = "Additional scripting to pass to the ec2 host. For example, this can include installing postgresql for the `psql` command."
  type        = string
  default     = ""
}

variable "allow_ssh_commands" {
  description = "Allows the SSH user to execute one-off commands. Pass 'True' to enable. Warning: These commands are not logged and increase the vulnerability of the system. Use at your own discretion."
  type        = string
  default     = "True"
}


variable "ebs_volume_size" {
  type = string
}

variable "instancetype" {
  description = "Instance size of the ec2"
  default     = "t3.nano"
}

variable "iaminstanceprofile" {
  description = "Instance size of the ec2"
  type        = string
}

variable "ec2securitygroups" {
  description = "List of Security groups attached to EC2."
  type        = list(string)
}
