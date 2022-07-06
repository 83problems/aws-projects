resource "aws_security_group" "allow_ssh" {
  name        = "host_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.vpc_primary.id

  tags = {
    Terraform = true
    Name = "allow_ssh"
  }
}

resource "aws_security_group" "allow_tls" {
  name        = "host_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.vpc_primary.id

  tags = {
    Terraform = true
    Name = "allow_tls"
  }
}

resource "aws_security_group_rule" "ssh" {
  description       = "Allow SSH"
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  security_group_id = aws_security_group.allow_ssh.id
  cidr_blocks       = ["10.0.0.0/8"]
}

resource "aws_security_group_rule" "https" {
  description       = "Allow HTTPS"
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.allow_tls.id
  cidr_blocks       = ["10.0.0.0/8"]
}

resource "aws_security_group_rule" "outbound" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = aws_security_group.allow_ssh.id
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "outbound_tenable_connections" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = aws_security_group.allow_tls.id
  cidr_blocks       = ["0.0.0.0/0"]
}
