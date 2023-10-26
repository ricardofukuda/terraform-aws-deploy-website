data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

data "aws_ami" "ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.10-hvm-2.0.20231012.1-x86_64-gp2"]
  }

  owners = ["amazon"]
}

data "aws_vpc" "selected" {
  filter {
    name   = "tag:Name"
    values = ["vpc-${var.environment}"]
  }
}

data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.selected.id]
  }

  tags = {
    Tier = "private"
  }
}

data "aws_lb" "selected" {
  name = local.lb_name
}

data "template_file" "user_data" {
  template = file("${path.module}/templates/user-data.sh.tpl")
  vars = {
    bucket_domain_name = aws_s3_bucket.bucket.bucket_domain_name
  }
}

data "template_file" "webpage" {
  template = file("${path.module}/templates/index.html.tpl")
  vars = {
    environment = lower(var.environment)
  }
}

data "aws_vpc_endpoint" "s3" {
  vpc_id       = data.aws_vpc.selected.id
  service_name = "com.amazonaws.${data.aws_region.current.name}.s3"
}

data "aws_lb_listener" "selected" {
  load_balancer_arn = data.aws_lb.selected.arn
  port              = 443
}

data "aws_route53_zone" "selected" {
  name         = var.domain
  private_zone = true
}
