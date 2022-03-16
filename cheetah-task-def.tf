resource "aws_ecs_task_definition" "cheetah_tf" {
  family                   = "uat-cheetah-tf" #unique name for your task def
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "1024"
  memory                   = "2048"
  task_role_arn            = "arn:aws:iam::${var.account}:role/ecsTaskExecutionRole"
  #task_role is for the java application to use AWS resources (sqs etc)
  execution_role_arn = "arn:aws:iam::${var.account}:role/ecsTaskExecutionRole"
  #execution_role is for ecs actions (pulling image from ecr etc)
  tags = var.cheetah_ecs_tags
  #added some new vars
  container_definitions = <<DEFINITION
[
  {
    "image": "${var.account}.dkr.ecr.${var.aw_region}.amazonaws.com/uat-cheetah-newdb:dd4c64c",
    "name": "uat-cheetah-tf",
    "logConfiguration": {
                "logDriver": "awslogs",
                "options": {
                    "awslogs-region" : "${var.aw_region}",
                    "awslogs-group" : "/ecs/uat-cheetah-tf",
                    "awslogs-stream-prefix" : "ecs"
                }
            },
    "portMappings":[{
            "containerPort": 80,
            "hostPort": 80 
    }],
    "environment": [
               {
          "name": "CLOUD_AWS_ENDPOINT",
          "value": "sqs.${var.aw_region}.amazonaws.com"
        },
        {
          "name": "CLOUD_AWS_S3_TEMPLATECOMPANYINVITATIONS3KEY",
          "value": "company_invitation_email_template.html"
        },
        {
          "name": "CLOUD_AWS_S3_TEMPLATERESETPASSWORDS3KEY",
          "value": "reset_password_email_template.txt"
        },
        {
          "name": "CLOUD_AWS_S3_TEMPLATES3BUCKET",
          "value": "aw-uat-email-template"
        },
        {
          "name": "CLOUD_AWS_S3_TEMPLATES3KEY",   
          "value": "verification_email_template_updated.html"
        },
        {
          "name": "CLOUD_AWS_SQS_INCOMINGQUEUE_NAME",
          "value": "AW_UAT_RECEIVE_Q"
        },
        {
          "name": "CLOUD_AWS_SQS_INCOMINGQUEUE_URL",
          "value": "https://sqs.${var.aw_region}.amazonaws.com/${var.account}/AW_UAT_RECEIVE_Q"
        },
        {
          "name": "CLOUD_AWS_SQS_OUTGOINGQUEUE_NAME",
          "value": "AwUatVerificationEmailBasicPP"
        },
        {
          "name": "CLOUD_AWS_SQS_OUTGOINGQUEUE_URL",
          "value": "https://sqs.${var.aw_region}.amazonaws.com/${var.account}/AwUatVerificationEmailBasicPP"
        },
        {
          "name": "SERVER_PORT",
          "value": "80"
        },
        {
          "name": "SPRING_FLYWAY_SCHEMA",
          "value": "awcheetah"
        },
        {
          "name": "SPRING_JPA_PROPERTIES_HIBERNATE_DEFAULT_SCHEMA",
          "value": "awcheetah"
        },
        {
          "name": "URL",
          "value": "https://${var.uat_domain}"
        }
      ],
      "resourceRequirements": null,
      "ulimits": null,
      "dnsServers": null,
      "mountPoints": [],
      "workingDirectory": null,
      "secrets": [
        {
          "valueFrom": "arn:aws:ssm:${var.aw_region}:${var.account}:parameter/AW_UAT_ECS_SQS_USER_KEY",
          "name": "CLOUD_AWS_CREDENTIALS_ACCESSKEY"
        },
        {
          "valueFrom": "arn:aws:ssm:${var.aw_region}:${var.account}:parameter/AW_UAT_ECS_SQS_USER_ACCESS",
          "name": "CLOUD_AWS_CREDENTIALS_SECRETKEY"
        },
        {
          "valueFrom": "arn:aws:ssm:${var.aw_region}:${var.account}:parameter/AW_CHEETAH_JWT_SECRET_KEY",
          "name": "JWT_SECRETKEY"
        },
        {
          "valueFrom": "arn:aws:ssm:${var.aw_region}:${var.account}:parameter/AW_UAT_DBPASS_TF",
          "name": "SPRING_DATASOURCE_PASSWORD"
        },
        {
          "valueFrom": "arn:aws:ssm:${var.aw_region}:${var.account}:parameter/AW_UAT_DB_URL_TF",
          "name": "SPRING_DATASOURCE_URL"
        }
        ]
     
    }
  
]
DEFINITION

}