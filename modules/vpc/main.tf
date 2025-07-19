resource "aws_vpc" "private_network" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.environment}-vpc"
  }
}

resource "aws_subnet" "public" {
  for_each = var.public_subnets

  vpc_id                  = aws_vpc.private_network.id
  cidr_block              = each.value.cidr_block
  availability_zone       = each.value.availability_zone
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.environment}-public-subnet-${each.key}"
  }
}

resource "aws_subnet" "private" {
  for_each = var.private_subnets

  vpc_id            = aws_vpc.private_network.id
  cidr_block        = each.value.cidr_block
  availability_zone = each.value.availability_zone

  tags = {
    Name = "${var.environment}-private-subnet-${each.key}"
  }
}

resource "aws_internet_gateway" "igw" {
  count  = local.use_igw ? 1 : 0
  vpc_id = aws_vpc.private_network.id

  tags = {
    Name = "${var.environment}-internet-gateway"
  }
}

resource "aws_eip" "nat_eip" {
  count  = local.use_nat_gateway ? 1 : 0
  domain = "vpc"

  tags = {
    Name = "${var.environment}-nat-eip"
  }
}

resource "aws_nat_gateway" "nat" {
  count = local.use_nat_gateway ? 1 : 0

  allocation_id = aws_eip.nat_eip[0].id
  subnet_id     = values(aws_subnet.public)[0].id

  tags = {
    Name = "${var.environment}-nat-gateway"
  }
}

resource "aws_route_table" "public_rt" {
  count  = local.use_igw ? 1 : 0
  vpc_id = aws_vpc.private_network.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw[0].id
  }

  tags = {
    Name = "${var.environment}-public-route-table"
  }
}

resource "aws_route_table_association" "public_assoc" {
  for_each = local.use_igw ? aws_subnet.public : {}

  subnet_id      = each.value.id
  route_table_id = aws_route_table.public_rt[0].id
}

resource "aws_route_table" "private_rt" {
  count  = local.use_private_rt ? 1 : 0
  vpc_id = aws_vpc.private_network.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat[0].id
  }

  tags = {
    Name = "${var.environment}-private-route-table"
  }
}

resource "aws_route_table_association" "private_assoc" {
  for_each = local.use_private_rt ? aws_subnet.private : {}

  subnet_id      = each.value.id
  route_table_id = aws_route_table.private_rt[0].id
}
