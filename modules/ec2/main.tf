locals {
  user_data = templatefile("${path.module}/user_data.sh", {})
}


resource "aws_launch_template" "ec2_launch_template" {
  name = var.ltresourcename
  #image_id      = var.ec2_ami != "" ? var.ec2_ami : data.aws_ssm_parameter.ami.value
  image_id      = var.ec2ami
  instance_type = var.instancetype
  monitoring {
    enabled = true
  }

  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      volume_size           = var.ebsvolumesize
      delete_on_termination = true
      volume_type           = "gp2"
      kms_key_id            = var.kmskeyid
      encrypted             = true
    }
  }

  network_interfaces {
    associate_public_ip_address = var.associatepublicipaddress
    security_groups             = var.ec2securitygroups
    delete_on_termination       = true
  }
  iam_instance_profile {
    name = var.iaminstanceprofile
  }
  #key_name = var.ec2_host_key_pair

  #user_data = base64encode(data.template_file.user_data.rendered)
  user_data = base64encode(local.user_data)

  tag_specifications {
    resource_type = "instance"
    tags          = merge(map("Name", var.ec2ltnametag), merge(var.tags))
  }

  tag_specifications {
    resource_type = "volume"
    tags          = merge(map("Name", var.ec2ltnametag), merge(var.tags))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "ec2_auto_scaling_group" {
  name = var.asgresourcename
  launch_template {
    id      = aws_launch_template.ec2_launch_template.id
    version = "$Latest"
  }
  max_size         = var.ec2_instance_count
  min_size         = var.ec2_instance_count
  desired_capacity = var.ec2_instance_count

  vpc_zone_identifier = var.autoscalinggroupsubnets

  default_cooldown          = 180
  health_check_grace_period = 180
  health_check_type         = "EC2"

  #target_group_arns = [
  #  aws_lb_target_group.ec2_lb_target_group.arn,
  #]

  termination_policies = [
    "OldestLaunchConfiguration",
  ]

  tags = concat(
    list(map("key", "Name", "value", "wba-asg-${local.name_prefix}", "propagate_at_launch", true)),
    local.tags_asg_format
  )

  lifecycle {
    create_before_destroy = true
  }
}
