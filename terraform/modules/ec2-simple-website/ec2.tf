resource "aws_instance" "simple_website" {
  ami                  = data.aws_ami.amazon_linux.id
  instance_type        = var.instance_type
  iam_instance_profile = aws_iam_instance_profile.ec2InstanceProfile.name

  key_name  = aws_key_pair.ec2_simple_website_key.key_name
  subnet_id = var.subnet.id
  user_data = templatefile("${path.module}/files/user_data.sh", {
    "aws_region" = var.aws_region
  })

  vpc_security_group_ids = [
    var.simple_website_sg.id,
  ]

  root_block_device {
    volume_size = var.disk_size
    encrypted   = true
  }

  ebs_block_device {
    device_name = "/dev/sdf"
    volume_size = var.ebs_disk_size
    encrypted   = true
  }

  associate_public_ip_address = false

  tags = {
    Terraform = true
    Name      = "ec2_simple_website"
  }
}

resource "aws_eip" "vpc_primary_eip_1" {
  vpc      = true
  instance = aws_instance.simple_website.id

  tags = {
    Terraform = true
    Name      = "Primary VPC EIP"
  }
}
