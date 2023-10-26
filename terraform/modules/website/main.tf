resource "aws_placement_group" "placement_group" {
  name     = local.name
  strategy = "spread" # spread the instances across different AZs
}

resource "aws_iam_instance_profile" "inst_profile" {
  name = local.name
  role = aws_iam_role.role.name
}

resource "aws_launch_template" "launch_template" {
  name_prefix   = local.name
  image_id      = data.aws_ami.ami.id
  instance_type = "t3a.small"

  # key_name = "" # block ssh access

  vpc_security_group_ids = [aws_security_group.sg.id]

  iam_instance_profile {
    name = aws_iam_instance_profile.inst_profile.name
  }

  user_data = base64encode(data.template_file.user_data.rendered)

  lifecycle {
    create_before_destroy = true
  }

  credit_specification {
    cpu_credits = "standard" # Prevent additional credits cost
  }

  placement {
    group_name = aws_placement_group.placement_group.name
  }

  tag_specifications {
    resource_type = "instance"

    tags = local.tags
  }

  tags = local.tags
}

resource "aws_security_group" "sg" {
  name        = local.name
  description = "for ${local.name}"
  vpc_id      = data.aws_vpc.selected.id

  ingress {
    description      = "HTTP from ALB"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = []
    ipv6_cidr_blocks = []
    security_groups  = data.aws_lb.selected.security_groups[*] # Only allows connections from ALB
  }

  egress {
    description      = "Out"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = local.tags
}

resource "aws_autoscaling_group" "asg" {
  name                = local.name
  desired_capacity    = 2
  min_size            = 2
  max_size            = 3
  vpc_zone_identifier = data.aws_subnets.private.ids

  target_group_arns = [aws_lb_target_group.alb_target_group.arn] # ALB target group

  launch_template {
    name    = aws_launch_template.launch_template.name
    version = "$Latest"
  }

  lifecycle {
    create_before_destroy = true
  }

  health_check_grace_period = 300
  health_check_type         = "ELB" # Enable HTTP health check
}

resource "aws_autoscaling_policy" "asg_policy" {
  name                   = local.name
  autoscaling_group_name = aws_autoscaling_group.asg.name
  policy_type            = "TargetTrackingScaling" # Scale in or out to keep CPU utilization around 50%

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 50.0
  }
}