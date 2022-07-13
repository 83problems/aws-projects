resource "aws_subnet" "vpc_primary_subpub_alb1" {
  vpc_id = aws_vpc.vpc_primary.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "${var.region}a"

  tags = {
    Terraform = true
    Name = "vpc_primary_subpub_alb1"
  }
}

resource "aws_subnet" "vpc_primary_subpub_alb2" {
  vpc_id = aws_vpc.vpc_primary.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "${var.region}b"

  tags = {
    Terraform = true
    Name = "vpc_primary_subpub_alb2"
  }
}

resource "aws_subnet" "vpc_primary_subpub_sha1" {
  vpc_id = aws_vpc.vpc_primary.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "${var.region}a"

  tags = {
    Terraform = true
    Name = "vpc_primary_subpub_sha1"
  }
}

resource "aws_subnet" "vpc_primary_subpub_sha2" {
  vpc_id = aws_vpc.vpc_primary.id
  cidr_block = "10.0.4.0/24"
  availability_zone = "${var.region}b"

  tags = {
    Terraform = true
    Name = "vpc_primary_subpub_sha2"
  }
}

resource "aws_subnet" "vpc_primary_subpri_app1" {
  vpc_id = aws_vpc.vpc_primary.id
  cidr_block = "10.0.5.0/24"
  availability_zone = "${var.region}a"

  tags = {
    Terraform = true
    Name = "vpc_primary_subpri_app1"
  }
}

resource "aws_subnet" "vpc_primary_subpri_app2" {
  vpc_id = aws_vpc.vpc_primary.id
  cidr_block = "10.0.6.0/24"
  availability_zone = "${var.region}b"

  tags = {
    Terraform = true
    Name = "vpc_primary_subpri_app2"
  }
}

resource "aws_subnet" "vpc_primary_subpri_db1" {
  vpc_id = aws_vpc.vpc_primary.id
  cidr_block = "10.0.7.0/24"
  availability_zone = "${var.region}a"

  tags = {
    Terraform = true
    Name = "vpc_primary_subpri_db1"
  }
}

resource "aws_subnet" "vpc_primary_subpri_db2" {
  vpc_id = aws_vpc.vpc_primary.id
  cidr_block = "10.0.8.0/24"
  availability_zone = "${var.region}b"

  tags = {
    Terraform = true
    Name = "vpc_primary_subpri_db2"
  }
}

resource "aws_internet_gateway" "vpc_primary_gateway" {
  vpc_id = aws_vpc.vpc_primary.id
  
  tags = {
    Terraform = true
    Name = "vpc_primary_internet_gateway"
  }
}

resource "aws_route_table" "vpc_primary_route_public" {
  vpc_id = aws_vpc.vpc_primary.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vpc_primary_gateway.id
  }

  tags = {
    Terraform = true
    Name = "vpc_primary_route_public"
  }
}

resource "aws_route_table_association" "vpc_primary_rt_alb1" {
  subnet_id = aws_subnet.vpc_primary_subpub_alb1.id
  route_table_id = aws_route_table.vpc_primary_route_public.id
}

resource "aws_route_table_association" "vpc_primary_rt_alb2" {
  subnet_id = aws_subnet.vpc_primary_subpub_alb2.id
  route_table_id = aws_route_table.vpc_primary_route_public.id
}

resource "aws_nat_gateway" "vpc_primary_ngw_1" {
  allocation_id = aws_eip.vpc_primary_eip_1.id
  subnet_id = aws_subnet.vpc_primary_subpub_sha1.id

  tags = {
    Terraform = true
    Name = "vpc_primary_ngw_1"
  }
  depends_on = [aws_internet_gateway.vpc_primary_gateway]
}

resource "aws_nat_gateway" "vpc_primary_ngw_2" {
  allocation_id = aws_eip.vpc_primary_eip_2.id
  subnet_id = aws_subnet.vpc_primary_subpub_sha2.id

  tags = {
    Terraform = true
    Name = "vpc_primary_ngw_2"
  }
  depends_on = [aws_internet_gateway.vpc_primary_gateway]
}

resource "aws_eip" "vpc_primary_eip_1" {
  vpc = true
  
  tags = {
    Terraform = true
    Name = "vpc_primary_eip_1"
  }
}

resource "aws_eip" "vpc_primary_eip_2" {
  vpc = true
  
  tags = {
    Terraform = true
    Name = "vpc_primary_eip_2"
  }
}

resource "aws_route_table" "vpc_primary_route_app1" {
  vpc_id = aws_vpc.vpc_primary.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.vpc_primary_ngw_1.id
  }

  tags = {
    Terraform = true
    Name = "vpc_primary_route_app1"
  }
}

resource "aws_route_table" "vpc_primary_route_app2" {
  vpc_id = aws_vpc.vpc_primary.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.vpc_primary_ngw_2.id
  }

  tags = {
    Terraform = true
    Name = "vpc_primary_route_app2"
  }
}

resource "aws_route_table_association" "vpc_primary_rt_app1" {
  subnet_id = aws_subnet.vpc_primary_subpri_app1.id
  route_table_id = aws_route_table.vpc_primary_route_app1.id
}

resource "aws_route_table_association" "vpc_primary_rt_app2" {
  subnet_id = aws_subnet.vpc_primary_subpri_app2.id
  route_table_id = aws_route_table.vpc_primary_route_app2.id
}

resource "aws_route_table" "vpc_primary_route_db1" {
  vpc_id = aws_vpc.vpc_primary.id

  tags = {
    Terraform = true
    Name = "vpc_primary_route_db1"
  }
}

resource "aws_route_table" "vpc_primary_route_db2" {
  vpc_id = aws_vpc.vpc_primary.id

  tags = {
    Terraform = true
    Name = "vpc_primary_route_db2"
  }
}

resource "aws_route_table_association" "vpc_primary_rt_db1" {
  subnet_id = aws_subnet.vpc_primary_subpri_db1.id
  route_table_id = aws_route_table.vpc_primary_route_db1.id
}

resource "aws_route_table_association" "vpc_primary_rt_db2" {
  subnet_id = aws_subnet.vpc_primary_subpri_db2.id
  route_table_id = aws_route_table.vpc_primary_route_db2.id
}

resource "aws_route_table" "vpc_primary_route_sha1" {
  vpc_id = aws_vpc.vpc_primary.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vpc_primary_gateway.id
  }

  tags = {
    Terraform = true
    Name = "vpc_primary_route_sha1"
  }
}

resource "aws_route_table" "vpc_primary_route_sha2" {
  vpc_id = aws_vpc.vpc_primary.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vpc_primary_gateway.id
  }

  tags = {
    Terraform = true
    Name = "vpc_primary_route_sha2"
  }
}

resource "aws_route_table_association" "vpc_primary_rt_sha1" {
  subnet_id = aws_subnet.vpc_primary_subpub_sha1.id
  route_table_id = aws_route_table.vpc_primary_route_sha1.id
}

resource "aws_route_table_association" "vpc_primary_rt_sha2" {
  subnet_id = aws_subnet.vpc_primary_subpub_sha2.id
  route_table_id = aws_route_table.vpc_primary_route_sha2.id
}

