# Get hosted zone details
data "aws_route53_zone" "hosted_zone" {
  name = var.domain_name # Make sure this matches exactly
}

# Create a record set in Route 53
resource "aws_route53_record" "site_domain" {
  zone_id = data.aws_route53_zone.hosted_zone.zone_id
  name    = var.record_name # Specify the subdomain or root domain
  type    = "A"

  alias {
    name                   = var.application_load_balancer_dns_name
    zone_id                = var.application_load_balancer_zone_id
    evaluate_target_health = true
  }
}
