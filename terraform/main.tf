module "ec2_simple_website" {
  source            = "./modules/ec2-simple-website"
  aws_region        = var.region
  instance_type     = var.instance_type
  subnet            = aws_subnet.public_subnet
  domainname        = var.domainname
  simple_website_sg = aws_security_group.simple_website_sg
}
