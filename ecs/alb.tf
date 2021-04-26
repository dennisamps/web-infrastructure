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
    type             = "forward"
    target_group_arn = aws_lb_target_group.ECS_TG.id
  }
}