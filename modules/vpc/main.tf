resource "aws_vpc" "noteit_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "noteit-${var.environment}-vpc"
  }
}

resource "aws_subnet" "noteit_public_subnet_a" {
  vpc_id                  = aws_vpc.noteit_vpc.id
  cidr_block              = var.public_subnet_a_cidr
  availability_zone       = var.availability_zones[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "noteit-${var.environment}-public-subnet-a"
  }
}

resource "aws_subnet" "noteit_public_subnet_b" {
  vpc_id                  = aws_vpc.noteit_vpc.id
  cidr_block              = var.public_subnet_b_cidr
  availability_zone       = var.availability_zones[1]
  map_public_ip_on_launch = true

  tags = {
    Name = "noteit-${var.environment}-public-subnet-b"
  }
}

resource "aws_subnet" "noteit_private_subnet_a" {
  vpc_id            = aws_vpc.noteit_vpc.id
  cidr_block        = var.private_subnet_a_cidr
  availability_zone = var.availability_zones[0]

  tags = {
    Name = "noteit-${var.environment}-private-subnet-a"
  }
}

resource "aws_subnet" "noteit_private_subnet_b" {
  vpc_id            = aws_vpc.noteit_vpc.id
  cidr_block        = var.private_subnet_b_cidr
  availability_zone = var.availability_zones[1]

  tags = {
    Name = "noteit-${var.environment}-private-subnet-b"
  }
}

resource "aws_internet_gateway" "noteit_igw" {
  vpc_id = aws_vpc.noteit_vpc.id

  tags = {
    Name = "noteit-${var.environment}-internet-gateway"
  }
}

resource "aws_eip" "noteit_nat_eip" {
  domain = "vpc"

  tags = {
    Name = "noteit-${var.environment}-nat-eip"
  }
}

resource "aws_nat_gateway" "noteit_nat" {
  allocation_id = aws_eip.noteit_nat_eip.id
  subnet_id     = aws_subnet.noteit_public_subnet_a.id

  tags = {
    Name = "noteit-${var.environment}-nat-gateway"
  }
}

resource "aws_route_table" "noteit_public_rt" {
  vpc_id = aws_vpc.noteit_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.noteit_igw.id
  }

  tags = {
    Name = "noteit-${var.environment}-public-route-table"
  }
}

resource "aws_route_table_association" "noteit_public_association_a" {
  subnet_id      = aws_subnet.noteit_public_subnet_a.id
  route_table_id = aws_route_table.noteit_public_rt.id
}

resource "aws_route_table_association" "noteit_public_association_b" {
  subnet_id      = aws_subnet.noteit_public_subnet_b.id
  route_table_id = aws_route_table.noteit_public_rt.id
}

resource "aws_route_table" "noteit_private_rt" {
  vpc_id = aws_vpc.noteit_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.noteit_nat.id
  }

  tags = {
    Name = "noteit-${var.environment}-private-route-table"
  }
}

resource "aws_route_table_association" "noteit_private_association_a" {
  subnet_id      = aws_subnet.noteit_private_subnet_a.id
  route_table_id = aws_route_table.noteit_private_rt.id
}

resource "aws_route_table_association" "noteit_private_association_b" {
  subnet_id      = aws_subnet.noteit_private_subnet_b.id
  route_table_id = aws_route_table.noteit_private_rt.id
}
