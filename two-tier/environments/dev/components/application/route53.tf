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

  depends_on = [aws_lb.public_alb]
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate#referencing-domain_validation_options-with-for_each-based-resources
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/guides/version-3-upgrade
resource "aws_route53_record" "root_validation" {
  zone_id = data.aws_route53_zone.root.id
  name    = tolist(aws_acm_certificate.acm_cert.domain_validation_options)[0].resource_record_name
  type    = tolist(aws_acm_certificate.acm_cert.domain_validation_options)[0].resource_record_type
  records = [tolist(aws_acm_certificate.acm_cert.domain_validation_options)[0].resource_record_value]
  ttl     = 60
}
