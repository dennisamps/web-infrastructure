resource "aws_appautoscaling_target" "ecs_target" {
  max_capacity       = 4
  min_capacity       = 1
  resource_id        = "service/${aws_ecs_cluster.ecs-cluster.name}/${aws_ecs_service.nginx-service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_cloudwatch_metric_alarm" "cpu-high" {
  alarm_name                = "${local.name}-cpu-high"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/ECS"
  period                    = "120"
  statistic                 = "Average"
  threshold                 = "80"
  alarm_description         = "This metric monitors ecs cpu utilization"

  dimensions = {
    ClusterName = aws_ecs_cluster.ecs-cluster.name
    ServiceName = aws_ecs_service.nginx-service.name
  }

  alarm_actions = [aws_appautoscaling_policy.ecs-up.arn]


}

resource "aws_cloudwatch_metric_alarm" "cpu-low" {
  alarm_name                = "${local.name}-cpu-low"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/ECS"
  period                    = "120"
  statistic                 = "Average"
  threshold                 = "50"
  alarm_description         = "This metric monitors ecs cpu utilization"

  dimensions = {
    ClusterName = aws_ecs_cluster.ecs-cluster.name
    ServiceName = aws_ecs_service.nginx-service.name
  }

  alarm_actions = [aws_appautoscaling_policy.ecs-down.arn]

}

resource "aws_appautoscaling_policy" "ecs-down" {
  name               = "${local.name}-scale-down"
  policy_type        = "StepScaling"
  resource_id        = aws_appautoscaling_target.ecs_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target.service_namespace

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 60
    metric_aggregation_type = "Average"

    step_adjustment {
      metric_interval_upper_bound = 0
      scaling_adjustment          = -1
    }
  }
}

resource "aws_appautoscaling_policy" "ecs-up" {
  name               = "${local.name}-scale-up"
  policy_type        = "StepScaling"
  resource_id        = aws_appautoscaling_target.ecs_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target.service_namespace

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 60
    metric_aggregation_type = "Average"

    step_adjustment {
      metric_interval_upper_bound = 0
      scaling_adjustment          = 1
    }
  }
}


resource "aws_ecs_capacity_provider" "ecs-capacity-provider" {
  name = "test"

  auto_scaling_group_provider {
    auto_scaling_group_arn         = aws_autoscaling_group.web_server.arn
    managed_termination_protection = "DISABLED"

    managed_scaling {
      maximum_scaling_step_size = 4
      minimum_scaling_step_size = 1
      status                    = "ENABLED"
      target_capacity           = 10
    }
  }
}



resource "aws_autoscaling_group" "web_server" {
  name = "ECS ASG"
  min_size = "1"
  max_size = "2"
  desired_capacity = "2"
  launch_configuration = aws_launch_configuration.web_server_lc.id
  vpc_zone_identifier = data.aws_subnet_ids.private.ids
  target_group_arns     = [aws_lb_target_group.ECS_TG.arn]
}

resource "aws_launch_configuration" "web_server_lc" {
  name                          = "${local.name}-server-lc"
  image_id                      = var.ami
  instance_type                 = var.instance-type
  iam_instance_profile          = aws_iam_instance_profile.ecs_service_role.name
  security_groups               = [aws_security_group.ECS-SG.id]
  # key_name = "ecs-key"
  # associate_public_ip_address = true
  user_data                     = templatefile("templates/configurations.sh", {
    tester = aws_ecs_cluster.ecs-cluster.name
  })





}
