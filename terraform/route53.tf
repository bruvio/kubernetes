resource "aws_route53_record" "some-application" {
  # DNS zone ID
  zone_id = "Z01104713294GHMBIFP6F" # Replace with your Route 53 Hosted Zone ID

  # DNS record
  name    = "app.brunoviola.net"
  type    = "CNAME"
  ttl     = 300
  records = ["${module.bruvio.ingress_dns_name}."]
}