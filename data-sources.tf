variable "alb_arn" {
  type    = string
  default = ""
}

variable "alb_name" {
  type    = string
  default = ""
}

/* data "aws_alb" "ecs_tf" {
  arn  = var.alb_arn
  name = var.alb_name
} */

data "aws_vpc" "main" {
  filter {
    name   = "tag:Name"
    values = ["ecs"]
  }

}

/* data "aws_subnet" "selected"{
    filter {
        name = "tag:Name"
        values = ["async-working-dev/Public"]
    }
} */

data "aws_subnet" "ecs_2a" {
  filter {
    name   = "tag:SELECTED"
    values = ["EKS_2a"]
  }
}

data "aws_subnet" "ecs_2b" {
  filter {
    name   = "tag:SELECTED"
    values = ["EKS_2b"]
  }
}


data "aws_ecr_image" "uat_cheetah" {
  repository_name = "uat-cheetah-newdb"
  image_tag       = "ee0f52e"
}

data "aws_subnet_ids" "ecs_subnets" {
  vpc_id = data.aws_vpc.main.id
  filter {
    name   = "tag:Name"
    values = ["async*"]
  }
}