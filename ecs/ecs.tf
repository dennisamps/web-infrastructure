resource "aws_ecs_cluster" "ecs-cluster" {
  name = "${local.name}-server"
}

resource "aws_ecs_task_definition" "nginx-definition" {
  family                = local.name
  container_definitions = templatefile("task-definitions/nginx-definition.json", {
    ecs-log-group = aws_cloudwatch_log_group.ecs-log.name
    region        = var.region
  })

  volume {
    name = "nginx"
  }

}

resource "aws_ecs_service" "nginx-service" {
  name = "nginx"
  cluster = aws_ecs_cluster.ecs-cluster.id
  task_definition = aws_ecs_task_definition.nginx-definition.id
  desired_count = 2
  scheduling_strategy = "REPLICA"
  launch_type = "EC2"

  load_balancer {
    target_group_arn = aws_lb_target_group.ECS_TG.arn
    container_name   = "nginx"
    container_port   = 80
  }
}

resource "aws_cloudwatch_log_group" "ecs-log" {
  name              = "/ecslogs/nginx-servers"
  retention_in_days = 30
}

resource "aws_cloudwatch_log_stream" "eecs-log-stream" {
  name           = "nginx-log-stream"
  log_group_name = aws_cloudwatch_log_group.ecs-log.name
}



