resource "aws_ecs_cluster" "ecs-cluster" {
  name = "${local.name}-server"
}

resource "aws_ecs_task_definition" "nginx-definition" {
  family                = local.name
  container_definitions = file("task-definitions/nginx-definition.json")

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