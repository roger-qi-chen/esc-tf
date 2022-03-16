aws_credentials = "/home/john/.aws/credentials"
profile         = "hammer"
aw_region       = "ap-southeast-2"

aw_az = "ap-southeast-2a"

cheetah_ecs_tags = {
  NAME   = "AW_CHEETAH"
  TOOL   = "TERRAFORM"
  CREATE = "JOHNWU"
  ENV    = "UAT"
}


/* alb_arn        = "arn:aws:elasticloadbalancing:ap-southeast-2:245866473499:loadbalancer/app/uat-cheetah-newDB-ALB/64e725eea6bdb9f1"
alb_name       = "uat-cheetah-newDB-ALB" */
vpc_cidr_block = "10.0.0.0/16"


ports_map_i = {
  #"22"  = ["0.0.0.0/0" , "101.182.42.66/32"]
  "80"   = ["0.0.0.0/0"]
  "8080" = ["0.0.0.0/0"]
  #"443" = ["0.0.0.0/0"]
}


ports_map_e = {
  #"22"  = ["0.0.0.0/0" , "101.182.42.66/32"]
  "0" = ["0.0.0.0/0"]
  #"8080" = ["0.0.0.0/0"]
  #"443" = ["0.0.0.0/0"]
}

ports_map_in = {
  #"22"  = ["0.0.0.0/0" , "101.182.42.66/32"]
  #"80"   = ["0.0.0.0/0"]
  #"8080" = ["0.0.0.0/0"]
  "443" = ["0.0.0.0/0"]
}

ports_map_out = {
  #"22"  = ["0.0.0.0/0" , "101.182.42.66/32"]
  #"80"   = ["0.0.0.0/0"]
  #"8080" = ["0.0.0.0/0"]
  "0" = ["0.0.0.0/0"]
}
account = "245866473499"


/* instance_tags = {
  NAME   = "ECS_TF"
  TOOL   = "TERRAFORM"
  CREATE = "JOHNWU"
} */

aw_hostzone = "asyncworking.com"

uat_domain = "uat.asyncworking.com"

additional_names = ["api.uat.asyncworking.com"]

health_check_path = "/api/v1/actuator/health"

alb_dns_record_name = "api.uat.asyncworking.com"