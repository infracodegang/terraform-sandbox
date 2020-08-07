output "alb_dns_name" {
  value       = aws_lb.public_alb.dns_name
  description = ""
}

output "domain_name" {
  value       = aws_route53_record.root.name
  description = ""
}
