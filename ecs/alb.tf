resource "aws_lb" "main-lb" {
  name = "${local.name}"
  internal            = false
  load_balancer_type  = "application"
  security_groups     = [aws_security_group.ALB-SG.id]
  subnets             = data.aws_subnet_ids.public.ids
}

resource "aws_lb_target_group" "ECS_TG" {
  name = local.name
  port        = 80
  target_type = "instance"
  protocol    = "HTTP"
  vpc_id      = data.aws_vpc.vpc.id

  health_check {
    path = "/"
    matcher = "200-399"
  }
}


resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.main-lb.id
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "redirect"
    
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "https_listener" {
  load_balancer_arn = aws_lb.main-lb.id
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS-1-2-2017-01"
  certificate_arn   = data.aws_acm_certificate.ssl_cert.id

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ECS_TG.id
  }
}

resource "aws_route53_record" "a_record" {
  zone_id = data.aws_route53_zone.zone_name.zone_id
  name    = var.a-record-domain-name
  type    = "A"
  alias {
    name                   = aws_lb.main-lb.dns_name
    zone_id                = aws_lb.main-lb.zone_id
    evaluate_target_health = true
  }
}
