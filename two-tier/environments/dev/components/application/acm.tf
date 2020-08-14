# resource "aws_acm_certificate" "acm_cert" {
#   domain_name               = var.domain_name
#   subject_alternative_names = []
#   validation_method         = "DNS"

#   lifecycle {
#     create_before_destroy = true
#   }
# }

# # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate_validation
# resource "aws_acm_certificate_validation" "acm_cert" {
#   certificate_arn         = aws_acm_certificate.acm_cert.arn
#   validation_record_fqdns = [aws_route53_record.root_validation.fqdn]

#   depends_on = [aws_route53_record.root_validation]
# }
