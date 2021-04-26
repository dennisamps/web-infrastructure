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

  
#   <<EOF
# #! /bin/bash
# sudo apt-get update
# sudo echo "ECS_CLUSTER=${aws_ecs_cluster.ecs-cluster.name}" >> /etc/ecs/ecs.config

# EOF
  



}
