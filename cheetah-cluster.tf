
/* resource "aws_kms_key" "cheetah_log" {
  description             = "awslog for cheetah cluster tf"
  deletion_window_in_days = 7
} */

resource "aws_cloudwatch_log_group" "cheetah_tf" {
  name = "uat-cheetah-tf"
}

resource "aws_ecs_cluster" "cheetah_tf" {
  name = "uat-cheetah-tf"

  configuration {
    execute_command_configuration {
      #kms_key_id = aws_kms_key.cheetah_log.arn
      logging = "OVERRIDE"

      log_configuration {
        #cloud_watch_encryption_enabled = true
        cloud_watch_log_group_name = aws_cloudwatch_log_group.cheetah_tf.name
      }
    }
  }
  tags = var.cheetah_ecs_tags
}