resource "aws_acm_certificate" "uat_domain_cert" {
  domain_name               = var.uat_domain
  subject_alternative_names = var.additional_names
  validation_method         = "DNS"

  tags = var.cheetah_ecs_tags

  lifecycle {
    create_before_destroy = true
  }

}

data "aws_route53_zone" "async_hz" {
  name         = var.aw_hostzone #the hostzone name "asyncworking.com"
  private_zone = false
}

resource "aws_acm_certificate_validation" "uat_cert_validation" {
  certificate_arn         = aws_acm_certificate.uat_domain_cert.arn
  validation_record_fqdns = [for record in aws_route53_record.uat_domain_record : record.fqdn]
}

resource "aws_route53_record" "uat_domain_record" {
  for_each = {
    for dvo in aws_acm_certificate.uat_domain_cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.async_hz.zone_id
}

output "fqdn" {
  value = [for record in aws_route53_record.uat_domain_record : record.fqdn]
}
output "dvo" {
  value = [for dvo in aws_acm_certificate.uat_domain_cert.domain_validation_options : dvo.domain_name]
}
output "type" {
  value = [for dvo in aws_acm_certificate.uat_domain_cert.domain_validation_options : dvo.resource_record_value]

}