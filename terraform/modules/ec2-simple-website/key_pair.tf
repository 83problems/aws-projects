resource "tls_private_key" "ec2_simple_website" {
  algorithm = "RSA"
  rsa_bits = 4096
}

resource "aws_key_pair" "ec2_simple_website_key" {
  key_name = "ec2-simple-website-key"
  public_key = tls_private_key.ec2_simple_website.public_key_openssh
}

resource "local_file" "ssh_key" {
  filename = "files/${aws_key_pair.ec2_simple_website_key.key_name}.pem"
  content = tls_private_key.ec2_simple_website.private_key_pem
}
