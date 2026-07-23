#############################################
# VPC
#############################################

resource "aws_vpc" "main" {

  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.project_name}-${var.environment}-vpc"
  }
}

#############################################
# Internet Gateway
#############################################

resource "aws_internet_gateway" "main" {

  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.project_name}-${var.environment}-igw"
  }
}

#############################################
# Elastic IP for NAT Gateway
#############################################

resource "aws_eip" "nat" {

  domain = "vpc"

  tags = {
    Name = "${var.project_name}-${var.environment}-nat-eip"
  }

  depends_on = [
    aws_internet_gateway.main
  ]
}

#############################################
# Public Subnet 1
#############################################

resource "aws_subnet" "public_1" {

  vpc_id = aws_vpc.main.id

  cidr_block = var.public_subnet_cidrs[0]

  availability_zone = var.availability_zones[0]

  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name}-${var.environment}-public-subnet-1"
    Tier = "Public"
  }

}

#############################################
# Public Subnet 2
#############################################

resource "aws_subnet" "public_2" {

  vpc_id = aws_vpc.main.id

  cidr_block = var.public_subnet_cidrs[1]

  availability_zone = var.availability_zones[1]

  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name}-${var.environment}-public-subnet-2"
    Tier = "Public"
  }

}

#############################################
# Private Application Subnet 1
#############################################

resource "aws_subnet" "private_app_1" {

  vpc_id = aws_vpc.main.id

  cidr_block = var.private_app_subnet_cidrs[0]

  availability_zone = var.availability_zones[0]

  tags = {
    Name = "${var.project_name}-${var.environment}-private-app-1"
    Tier = "Application"
  }

}

#############################################
# Private Application Subnet 2
#############################################

resource "aws_subnet" "private_app_2" {

  vpc_id = aws_vpc.main.id

  cidr_block = var.private_app_subnet_cidrs[1]

  availability_zone = var.availability_zones[1]

  tags = {
    Name = "${var.project_name}-${var.environment}-private-app-2"
    Tier = "Application"
  }

}

#############################################
# Private Database Subnet 1
#############################################

resource "aws_subnet" "private_db_1" {

  vpc_id = aws_vpc.main.id

  cidr_block = var.private_db_subnet_cidrs[0]

  availability_zone = var.availability_zones[0]

  tags = {
    Name = "${var.project_name}-${var.environment}-private-db-1"
    Tier = "Database"
  }

}

#############################################
# Private Database Subnet 2
#############################################

resource "aws_subnet" "private_db_2" {

  vpc_id = aws_vpc.main.id

  cidr_block = var.private_db_subnet_cidrs[1]

  availability_zone = var.availability_zones[1]

  tags = {
    Name = "${var.project_name}-${var.environment}-private-db-2"
    Tier = "Database"
  }

}

#############################################
# NAT Gateway
#############################################

resource "aws_nat_gateway" "main" {

  allocation_id = aws_eip.nat.id

  subnet_id = aws_subnet.public_1.id

  tags = {
    Name = "${var.project_name}-${var.environment}-nat"
  }

  depends_on = [
    aws_internet_gateway.main
  ]
}

#############################################
# Public Route Table
#############################################

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.project_name}-${var.environment}-public-rt"
  }
}

#############################################
# Public Route
#############################################

resource "aws_route" "public_internet_access" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id
}

#############################################
# Public Route Table Associations
#############################################

resource "aws_route_table_association" "public_1" {
  subnet_id      = aws_subnet.public_1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_2" {
  subnet_id      = aws_subnet.public_2.id
  route_table_id = aws_route_table.public.id
}

#############################################
# Private Route Table
#############################################

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.project_name}-${var.environment}-private-rt"
  }
}

#############################################
# Private Route
#############################################

resource "aws_route" "private_nat_gateway" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.main.id
}

#############################################
# Private Application Route Table Associations
#############################################

resource "aws_route_table_association" "private_app_1" {
  subnet_id      = aws_subnet.private_app_1.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_app_2" {
  subnet_id      = aws_subnet.private_app_2.id
  route_table_id = aws_route_table.private.id
}

#############################################
# Private Database Route Table Associations
#############################################

resource "aws_route_table_association" "private_db_1" {
  subnet_id      = aws_subnet.private_db_1.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_db_2" {
  subnet_id      = aws_subnet.private_db_2.id
  route_table_id = aws_route_table.private.id
}