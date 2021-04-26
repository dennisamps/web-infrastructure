#! /bin/bash
sudo apt-get update
sudo echo "ECS_CLUSTER=${tester}" >> /etc/ecs/ecs.config