resource "aws_cloudwatch_log_group" "cheetah_tf_loggroup" {
  name              = "/ecs/uat-cheetah-tf"
  retention_in_days = 30
  tags              = var.cheetah_ecs_tags
}

resource "aws_cloudwatch_log_stream" "cheetat_tf_log_stream" {
  name           = "cheetah-tf-long-stream"
  log_group_name = aws_cloudwatch_log_group.cheetah_tf_loggroup.name
}