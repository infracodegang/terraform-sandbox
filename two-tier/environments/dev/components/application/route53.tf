data "aws_route53_zone" "root" {
  name = var.domain_name
}

resource "aws_route53_record" "root" {
  zone_id = data.aws_route53_zone.root.zone_id
  name    = data.aws_route53_zone.root.name
  type    = "A"

  alias {
    name                   = aws_lb.public_alb.dns_name
    zone_id                = aws_lb.public_alb.zone_id
    evaluate_target_health = true
  }
}

resource "aws_acm_certificate" "acm_cert" {
  domain_name               = var.domain_name
  subject_alternative_names = []
  validation_method         = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate#referencing-domain_validation_options-with-for_each-based-resources
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/guides/version-3-upgrade
resource "aws_route53_record" "root_validation" {
  name    = tolist(aws_acm_certificate.acm_cert.domain_validation_options)[0].resource_record_name
  type    = tolist(aws_acm_certificate.acm_cert.domain_validation_options)[0].resource_record_type
  records = [tolist(aws_acm_certificate.acm_cert.domain_validation_options)[0].resource_record_value]
  zone_id = data.aws_route53_zone.root.id
  ttl     = 60
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate_validation
resource "aws_acm_certificate_validation" "acm_cert" {
  certificate_arn         = aws_acm_certificate.acm_cert.arn
  validation_record_fqdns = [aws_route53_record.root_validation.fqdn]
}
