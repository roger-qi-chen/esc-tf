resource "aws_route53_record" "alb_record_atype" {
  zone_id = data.aws_route53_zone.async_hz.zone_id
  name    = var.alb_dns_record_name #api.uat.asyncworking.com"
  type    = "A"

  alias {
    #name                   = "jenkins-alb-1028719094.ap-southeast-2.elb.amazonaws.com" 
    name = aws_alb.ecs-tf-alb.dns_name #aws_alb.ecs-tf-alb.dns_name #
    #zone_id                = "Z1GM3OXH4ZPM65"   
    zone_id = aws_alb.ecs-tf-alb.zone_id #data.aws_alb.jenkins-alb.zone_id
    evaluate_target_health = true
  }
}