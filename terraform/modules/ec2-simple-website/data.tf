data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = [var.amazon_linux_ami]
  }
}

data "template_file" "userdata" {
  template = file("${path.module}/files/user_data.sh")

  vars = {
    "aws_region" = var.aws_region
  }
}

data "aws_route53_zone" "primary" {
  name = "${var.domainname}."
}

data "aws_caller_identity" "current" {
}
