resource "aws_network_acl" "vpc_primary_acl_app" {
  vpc_id     = aws_vpc.vpc_primary.id
  subnet_ids = [aws_subnet.vpc_primary_subpri_app1.id, aws_subnet.vpc_primary_subpri_app2.id]

  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 80
    to_port    = 80
  }

  egress {
    protocol   = "tcp"
    rule_no    = 150
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 443
    to_port    = 443
  }

  egress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = var.vpc_primary_cidr
    from_port  = 0
    to_port    = 0
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 50
    action     = "allow"
    cidr_block = var.vpc_primary_cidr
    from_port  = 80
    to_port    = 80
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = var.vpc_primary_cidr
    from_port  = 443
    to_port    = 443
  }

  tags = {
    Terraform = true
    Name      = "nacl_app"
  }
}

resource "aws_network_acl" "vpc_primary_acl_db" {
  vpc_id     = aws_vpc.vpc_primary.id
  subnet_ids = [aws_subnet.vpc_primary_subpri_db1.id, aws_subnet.vpc_primary_subpri_db2.id]

  egress {
    protocol   = "tcp"
    rule_no    = 50
    action     = "allow"
    cidr_block = aws_subnet.vpc_primary_subpri_db1.cidr_block
    from_port  = 1024
    to_port    = 65535
  }

  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = aws_subnet.vpc_primary_subpri_db2.cidr_block
    from_port  = 1024
    to_port    = 65535
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 50
    action     = "allow"
    cidr_block = aws_subnet.vpc_primary_subpri_db1.cidr_block
    from_port  = 3306
    to_port    = 3306
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = aws_subnet.vpc_primary_subpri_db2.cidr_block
    from_port  = 3306
    to_port    = 3306
  }

  tags = {
    Terraform = true
    Name      = "nacl_db"
  }
}

resource "aws_network_acl" "vpc_primary_acl_alb" {
  vpc_id     = aws_vpc.vpc_primary.id
  subnet_ids = [aws_subnet.vpc_primary_subpub_alb1.id, aws_subnet.vpc_primary_subpub_alb2.id]

  egress {
    protocol   = "tcp"
    rule_no    = 50
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1024
    to_port    = 65535
  }

  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = aws_subnet.vpc_primary_subpub_alb1.cidr_block
    from_port  = 80
    to_port    = 80
  }

  egress {
    protocol   = "tcp"
    rule_no    = 150
    action     = "allow"
    cidr_block = aws_subnet.vpc_primary_subpub_alb2.cidr_block
    from_port  = 80
    to_port    = 80
  }

  egress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = aws_subnet.vpc_primary_subpub_alb1.cidr_block
    from_port  = 443
    to_port    = 443
  }

  egress {
    protocol   = "tcp"
    rule_no    = 250
    action     = "allow"
    cidr_block = aws_subnet.vpc_primary_subpub_alb2.cidr_block
    from_port  = 443
    to_port    = 443
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 80
    to_port    = 80
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 150
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 443
    to_port    = 443
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = aws_subnet.vpc_primary_subpub_alb1.cidr_block
    from_port  = 1024
    to_port    = 65535
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 250
    action     = "allow"
    cidr_block = aws_subnet.vpc_primary_subpub_alb2.cidr_block
    from_port  = 1024
    to_port    = 65535
  }

  tags = {
    Terraform = true
    Name      = "nacl_alb"
  }
}

resource "aws_network_acl" "vpc_primary_acl_sha" {
  vpc_id     = aws_vpc.vpc_primary.id
  subnet_ids = [aws_subnet.vpc_primary_subpub_sha1.id, aws_subnet.vpc_primary_subpub_sha2.id]

  egress {
    protocol   = "tcp"
    rule_no    = 50
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1024
    to_port    = 65535
  }

  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 80
    to_port    = 80
  }

  egress {
    protocol   = "tcp"
    rule_no    = 150
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 80
    to_port    = 80
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 50
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1024
    to_port    = 65535
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = aws_subnet.vpc_primary_subpub_sha1.cidr_block
    from_port  = 0
    to_port    = 0
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 150
    action     = "allow"
    cidr_block = aws_subnet.vpc_primary_subpub_sha2.cidr_block
    from_port  = 0
    to_port    = 0
  }

  tags = {
    Terraform = true
    Name      = "nacl_sha"
  }
}

