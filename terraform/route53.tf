resource "aws_route53domains_registered_domain" "route_53_reg_domain" {
  domain_name        = var.domainname
  admin_privacy      = true
  registrant_privacy = true
  tech_privacy       = true
  transfer_lock      = true

  tags = {
    Terraform = true
    Name      = "aws_route53domains_registered"
  }
}
