resource "aws_vpc" "vpc_primary" {
  cidr_block = var.vpc_primary_cidr
  instance_tenancy = "default"
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
    Terraform = true
    Name = "Primary VPC"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id = aws_vpc.vpc_primary.id
  cidr_block = var.public_subnet_cidr
  availability_zone = "${var.region}a"

  tags = {
    Terraform = true
    Name = "Public Subnet CIDR"
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id = aws_vpc.vpc_primary.id
  cidr_block = var.private_subnet_cidr
  availability_zone = "${var.region}a"

  tags = {
    Terraform = true
    Name = "Private Subnet CIDR"
  }
}

resource "aws_internet_gateway" "vpc_primary_gateway" {
  vpc_id = aws_vpc.vpc_primary.id
  
  tags = {
    Terraform = true
    Name = "Primary VPC Internet Gateway"
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
    Name = "Public Subnet Route Table"
  }
}

resource "aws_route_table_association" "vpc_primary_rt_pub_assoc" {
  subnet_id = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.vpc_primary_route_public.id
}
