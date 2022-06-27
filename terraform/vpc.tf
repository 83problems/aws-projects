resource "aws_vpc" "vpc_primary" {
  cidr_block = var.vpc_primary_cidr
  instance_tenancy = "default"
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
    Terraform = true
    Name = "vpc_primary"
  }
}

resource "aws_subnet" "vpc_primary_subpub_1a" {
  vpc_id = aws_vpc.vpc_primary.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "${var.region}a"

  tags = {
    Terraform = true
    Name = "vpc_primary_subpub_1a"
  }
}

resource "aws_subnet" "vpc_primary_subpub_1b" {
  vpc_id = aws_vpc.vpc_primary.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "${var.region}b"

  tags = {
    Terraform = true
    Name = "vpc_primary_subpub_1b"
  }
}

resource "aws_subnet" "vpc_primary_subpri_1a" {
  vpc_id = aws_vpc.vpc_primary.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "${var.region}a"

  tags = {
    Terraform = true
    Name = "vpc_primary_subpri_1a"
  }
}

resource "aws_subnet" "vpc_primary_subpri_1b" {
  vpc_id = aws_vpc.vpc_primary.id
  cidr_block = "10.0.4.0/24"
  availability_zone = "${var.region}b"

  tags = {
    Terraform = true
    Name = "vpc_primary_subpri_1b"
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

resource "aws_route_table_association" "vpc_primary_rt_2" {
  subnet_id = aws_subnet.vpc_primary_subpub_1a.id
  route_table_id = aws_route_table.vpc_primary_route_public.id
}

resource "aws_route_table_association" "vpc_primary_rt_4" {
  subnet_id = aws_subnet.vpc_primary_subpub_1b.id
  route_table_id = aws_route_table.vpc_primary_route_public.id
}

resource "aws_nat_gateway" "vpc_primary_ng" {
  allocation_id = aws_eip.vpc_primary_lb.id
  subnet_id = aws_subnet.vpc_primary_subpub_1a.id

  tags = {
    Terraform = true
    Name = "vpc_primary_ng"
  }
}

resource "aws_eip" "vpc_primary_lb" {
  vpc = true
  
  tags = {
    Terraform = true
    Name = "vpc_primary_lb"
  }
}

resource "aws_route_table" "vpc_primary_route_private" {
  vpc_id = aws_vpc.vpc_primary.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.vpc_primary_ng.id
  }

  tags = {
    Terraform = true
    Name = "vpc_primary_route_private"
  }
}

resource "aws_route_table_association" "vpc_primary_rt_1" {
  subnet_id = aws_subnet.vpc_primary_subpri_1a.id
  route_table_id = aws_route_table.vpc_primary_route_private.id
}

resource "aws_route_table_association" "vpc_primary_rt_3" {
  subnet_id = aws_subnet.vpc_primary_subpri_1b.id
  route_table_id = aws_route_table.vpc_primary_route_private.id
}

