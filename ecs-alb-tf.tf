
resource "aws_alb" "ecs-tf-alb" {
  name               = "ecs-tf-alb"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_ecs_tf.id]
  subnets            = data.aws_subnet_ids.ecs_subnets.ids
  tags               = var.cheetah_ecs_tags


}

resource "aws_security_group" "alb_ecs_tf" {
  name        = "alb-ecs-tf"
  description = "created by TF"
  vpc_id      = data.aws_vpc.main.id
  dynamic "ingress" {
    for_each = var.ports_map_in
    content {
      from_port   = ingress.key
      to_port     = ingress.key
      protocol    = "tcp"
      cidr_blocks = ingress.value
    }
  }
  dynamic "egress" {
    for_each = var.ports_map_out
    content {
      from_port   = egress.key
      to_port     = egress.key
      protocol    = "All"
      cidr_blocks = egress.value
    }
  }
  tags = var.cheetah_ecs_tags


}

resource "aws_alb_listener" "ecs_listener_tf" {
  load_balancer_arn = aws_alb.ecs-tf-alb.id
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS-1-2-Ext-2018-06" #ALB policy
  certificate_arn   = aws_acm_certificate.uat_domain_cert.arn
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs_svc_tf.arn
  }

}

resource "aws_lb_target_group" "ecs_svc_tf" {
  name        = "cheetah-svc-tf"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = data.aws_vpc.main.id
  tags        = var.cheetah_ecs_tags
  health_check {
    port                = 80
    path                = var.health_check_path
    interval            = 30
    healthy_threshold   = 5
    unhealthy_threshold = 2
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = 5
  }
}