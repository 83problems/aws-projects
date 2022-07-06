data "aws_ami" "amazon_linux" {
  most_recent = true
  owners = [ "amazon" ]
  
  filter {
    name = "name"
    values = [ var.amazon_linux_ami ]
  }
}

data "template_file" "userdata" {
  template = "${file("${path.module}/files/user_data.sh")}"

  vars = {
    "aws_region"       = var.aws_region
  }
}

resource "aws_instance" "simple_website" {
  ami = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type
  iam_instance_profile = aws_iam_instance_profile.ec2InstanceProfile.name

  key_name  = aws_key_pair.ec2_simple_website_key.key_name
  subnet_id = var.subnet.id
  user_data = data.template_file.userdata.rendered
  
  vpc_security_group_ids = [
    var.allow_ssh.id,
    var.allow_tls.id,
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
    Name = "ec2_simple_website"
  }
  
  #depends_on = [
  #  aws_subnet.subnet,
  #  aws_security_group.allow_ssh,
  #  aws_security_group.allow_tls
  #]
}
