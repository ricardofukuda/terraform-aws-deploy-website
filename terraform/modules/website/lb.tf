resource "aws_lb_target_group" "alb_target_group" {
  name     = local.name
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.selected.id

  tags = local.tags
}

resource "aws_lb_listener_rule" "host_based_routing" {
  listener_arn = data.aws_lb_listener.selected.arn
  priority     = 1

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_target_group.arn
  }

  condition {
    host_header {
      values = [local.service_adress]
    }
  }
}

resource "aws_route53_record" "main" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = local.service_adress
  type    = "A"

  alias {
    name                   = data.aws_lb.selected.dns_name
    zone_id                = data.aws_lb.selected.zone_id
    evaluate_target_health = true
  }
}
