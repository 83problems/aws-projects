resource "aws_route53_record" "www" {
  zone_id = data.aws_route53_zone.primary.zone_id
  name = "www.${data.aws_route53_zone.primary.name}"
  type = "A"
  ttl = "300"
  records = [aws_eip.vpc_primary_eip_1.public_ip]
}

resource "aws_route53_record" "non-www" {
  zone_id = data.aws_route53_zone.primary.zone_id
  name = "${data.aws_route53_zone.primary.name}"
  type = "A"
  ttl = "300"
  records = [aws_eip.vpc_primary_eip_1.public_ip]
}
