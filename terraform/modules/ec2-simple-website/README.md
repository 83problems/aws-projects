# EC2 instance with website

This module will create an EC2 instance running Linux. Once created, will configure Nginx to host a website and update DNS.

## Add module

This block can be added to `main.tf` in the Terraform root directory. Run `terraform` commands to implement.

```
module "ec2_simple_website" {
  source = "./modules/ec2-simple-website"
  aws_region = var.region
  instance_type = var.instance_type
  subnet = aws_subnet.public_subnet
  domainname = var.domainname
  simple_website_sg = aws_security_group.simple_website_sg
}
```
