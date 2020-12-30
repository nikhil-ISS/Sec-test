# VPC and Subnets
resource "aws_vpc" "vpc" {
  cidr_block           = "192.168.0.0/21"
  enable_dns_hostnames = true

  tags = {
    Name = "Test_VPC"
  }
}

resource "aws_subnet" "public" {
  tags = {
    Name = "Test_VPC_public_subnet"
  }

  vpc_id            = aws_vpc.vpc.id
  count             = length(var.availability_zones)
  availability_zone = "us-east-1${element(var.availability_zones, count.index)}"
  cidr_block        = cidrsubnet("192.168.0.0/22", 2, count.index)
}

resource "aws_subnet" "private" {
  tags = {
    Name = "Test_VPC_private_subnet"
  }

  vpc_id            = aws_vpc.vpc.id
  count             = length(var.availability_zones)
  availability_zone = "us-east-1${element(var.availability_zones, count.index)}"
  cidr_block        = cidrsubnet("192.168.4.0/22", 2, count.index)
}

# Routing
resource "aws_internet_gateway" "gateway" {
  tags = {
    Name = "Test_VPC_Internet_gateway"
  }

  vpc_id = aws_vpc.vpc.id
}

resource "aws_eip" "nat" {
  vpc = true
  tags = {
    role = "nat"
  }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public.0.id
}

resource "aws_route_table" "public" {
  tags = {
    Name = "Test_VPC_public_routes_table"
  }

  vpc_id = aws_vpc.vpc.id
}

resource "aws_route" "public_default" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gateway.id
}

resource "aws_route_table_association" "public" {


  count          = length(var.availability_zones)
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private" {
  tags = {
    Name = "Test_VPC_private_routes_table"
  }

  vpc_id = aws_vpc.vpc.id
}

resource "aws_route" "private_default" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id
}

resource "aws_route_table_association" "private" {

  count          = length(var.availability_zones)
  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = aws_route_table.private.id
}
