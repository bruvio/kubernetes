resource "aws_route53_record" "some-application" {
  # DNS zone ID
  zone_id = "Z01104713294GHMBIFP6F"

  # DNS record
  name    = "app.bruvio.brunoviola.net."
  type    = "CNAME"
  ttl     = 300
  records = ["${module.bruvio.ingress_dns_name}."]
}