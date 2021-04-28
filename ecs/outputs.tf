
output "url" {
    value = aws_route53_record.a_record.*.fqdn
}

