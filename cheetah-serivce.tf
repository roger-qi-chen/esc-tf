resource "aws_ecs_service" "cheetah_tf" {
  name            = "cheetah-svc-tf"
  cluster         = aws_ecs_cluster.cheetah_tf.id
  task_definition = aws_ecs_task_definition.cheetah_tf.arn
  desired_count   = var.container_desired_count
  #iam_role =  "arn:aws:iam::"${var.account}":role/aws-service-role/ecs.amazonaws.com/AWSServiceRoleForECS"
  #optional argument, only if not using awsvpc as network mode
  launch_type                       = "FARGATE"
  health_check_grace_period_seconds = "300"

  network_configuration {
    #subnets = [data.aws_subnet.ecs_2a.id, data.aws_subnet.ecs_2b.id]
    subnets          = data.aws_subnet_ids.ecs_subnets.ids
    security_groups  = [aws_security_group.cheetah_sg_tf.id]
    assign_public_ip = true

  }

  load_balancer {
    target_group_arn = aws_lb_target_group.ecs_svc_tf.arn
    container_name   = "uat-cheetah-tf"
    container_port   = 80
  }
  tags = var.cheetah_ecs_tags
  depends_on = [
    aws_alb_listener.ecs_listener_tf  #seems no imact with or without this
  ]
}

resource "aws_security_group" "cheetah_sg_tf" {
  name        = "uat-cheetah-sg-tf"
  description = "created by TF"
  vpc_id      = data.aws_vpc.main.id
  dynamic "ingress" {
    for_each = var.ports_map_i
    content {
      from_port   = ingress.key
      to_port     = ingress.key
      protocol    = "tcp"
      cidr_blocks = ingress.value
    }
  }
  dynamic "egress" {
    for_each = var.ports_map_e
    content {
      from_port   = egress.key
      to_port     = egress.key
      protocol    = "All"
      cidr_blocks = egress.value
    }
  }
  tags = var.cheetah_ecs_tags

}
