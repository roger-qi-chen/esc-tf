variable "aws_credentials" {
  type        = string
  description = "your own crendentials"
}

variable "profile" {
  type        = string
  description = "login profile"
}

variable "aw_region" {
  type        = string
  description = "local region"

}

variable "cheetah_ecs_tags" {
  type = object({
    NAME   = string
    TOOL   = string
    CREATE = string
    ENV    = string
  })

}

variable "health_check_path" {
  type        = string
  description = "healthcheck path for target group "

}

variable "vpc_cidr_block" {
  type        = string
  description = "default vpc cidr"

}


variable "ports_map_i" {
  type        = map(list(string))
  description = "tf_created_portmap ecs service"
}

variable "ports_map_e" {
  type        = map(list(string))
  description = "tf_created_portmap ecs service"
}
# variable "ports_map" {
#   type        = map(list(string))
#   description = "tf_created_portmap"
# }
variable "ports_map_in" {
  type        = map(list(string))
  description = "tf_created_portmap alb"
}

variable "container_desired_count" {
  type = number
  description = "number of container defined in ecs service "
  default = 2
}

variable "ports_map_out" {
  type        = map(list(string))
  description = "tf_created_portmap alb"
}

variable "account" {
  type = string

}

# variable "instance_tags" {
#   type = object({
#     NAME   = string
#     TOOL   = string
#     CREATE = string
#   })
# }

variable "aw_hostzone" {
  type        = string
  description = "aw public hostzone"

}

variable "uat_domain" {
  type        = string
  description = "uat portal"

}

variable "additional_names" {
  type        = list(string)
  description = "additional name in the SSL certificate"
}

variable "alb_dns_record_name" {
  type = string
}