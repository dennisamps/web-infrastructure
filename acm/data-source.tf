data "aws_route53_zone" "zone_name" {
  name         = var.zone_name
  private_zone = false
}